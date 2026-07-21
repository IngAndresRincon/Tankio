const pool = require("../../database/pg");
const { createHttpError } = require("../../common/http-error");


exports.register = async (data) => {

  const existUser = await this.getUserByEmail(data.email);
  if(existUser){
      const error = new Error('User already exists');
      error.statusCode = 409;
      error.code = '';
      throw error;
  }

  const user = await createNeUser(data);

  if(!user){
      const error = new Error('User could not be created');
      error.statusCode = 500;
      error.code = '';
      throw error;
  }

  return user;
};

exports.edit = async (id,data) => {

  const existEmail = await validRegisterEmail(id,data.email);
  if(existEmail){
      const error = new Error('Email already in use');
      error.statusCode = 409;
      error.code = '';
      throw error;
  }

  const user = await editUser(id,data);

  if(!user){
      const error = new Error('User not found');
      error.statusCode = 404;
      error.code = '';
      throw error;
  }

  return user;
};

exports.termsconditions = async (id) => {

  const existtc = await validExistsTermsConditions(id);
  if(!existtc){
      const error = new Error('Terms and conditions not found');
      error.statusCode = 404;
      error.code = '';
      throw error;
  }
  return existtc;
};

exports.registertermsconditions = async (data) => {

  const existtc = await validExistsTermsConditions(data.userid);
  if(existtc){
    const result = await updateTermsConditions(data);
    return result;
  }

  const result = await registerTermsConditions(data);
  return result;
};


exports.changepassword = async (id,data) => {
 const query = `UPDATE public.user SET key_hash = $1 WHERE id = $2 AND active = true RETURNING *;`;
 const result = await pool.query(query,[data.password,id]);
 return result.rowCount>0? result.rows[0]: null;
};



async function validExistsTermsConditions(id){
    const query = `SELECT * FROM public.terms_conditions WHERE user_id =$1 LIMIT 1;`;
    const result = await pool.query(query,[id]);
    return result.rows[0] || null;
}

async function registerTermsConditions(data){
    const query = `INSERT INTO public.terms_conditions (user_id,user_agree) VALUES($1,$2) RETURNING *;`;
    const result = await pool.query(query,[data.userid,data.isagreed]);
    return result.rows[0] || null;
}


async function updateTermsConditions(data){
    const query = `UPDATE public.terms_conditions SET user_agree =$1 ,registration_date = now()
    WHERE user_id=$2 RETURNING *;`;
    const result = await pool.query(query,[data.isagreed,data.userid]);
    return result.rows[0] || null;
}


async function validRegisterEmail(id,email){
    const query = `SELECT id FROM public.user 
    WHERE TRIM(email) = TRIM($1) AND active = true AND id != $2 LIMIT 1;`;
    const result = await pool.query(query,[email,id]);
    return result.rows[0] || null;
}

async function editUser(id,data){
    const query = `UPDATE public.user SET
    name = $1, last_name = $2, email = $3, document_type_id =$4, document_number=$5, phone_number=$6
    WHERE id = $7 RETURNING *;`;
    const result = await pool.query(query,[data.name,data.lastname,data.email,data.documenttype,data.documentnumber,data.phonenumber,id]);
    return result.rowCount>0 ? result.rows[0]: null;
}

exports.getUserByEmail = async (email)=>{
  const query = `SELECT  
  u.*,
  td.type as document_type
  FROM public.user as u
  INNER JOIN type.document as td
  ON u.document_type_id = td.id
  WHERE TRIM(email) = TRIM($1) AND u.active = true LIMIT 1;`;
  const result = await pool.query(query,[email]);
  return result.rowCount>0 ? result.rows[0]: null;
}


async function createNeUser(data){

  const query = `INSERT INTO public.user (name,last_name,email,key_hash,document_type_id,document_number,phone_number)
                  VALUES($1,$2,$3,$4,$5,$6,$7) RETURNING *;`;
  const result = await pool.query(query,[data.name,data.lastname,data.email,data.password,data.documenttype,data.documentnumber,data.phonenumber]);

  return result.rowCount>0 ? result.rows[0] : null;

}



exports.getVehiclesById=async (id)=>{
  const query = `SELECT * FROM public.vehicle WHERE user_id = $1 AND active = true;`;
  const result = await pool.query(query,[id]);
  return result.rowCount>0? result.rows : [];
}



exports.getBalanceById=async (id)=>{
  const query = ` SELECT 
                  b.id as balance_id,
                  b.user_id,
                  b.balance_amount as balance,
                  b.uuid as balance_uuid,
                  TO_CHAR(last_move_date,'YYYY-MM-DD HH24:MI:SS') as last_move_date,
                  g.id as group_id,
                  g.name as group_name,
                  g.company_name,
                  g.address,
                  g.prefix_code
                  FROM  public.balance as b
                  INNER JOIN public.group as g
                  ON b.group_id = g.id 
                  INNER JOIN public.user as u
                  ON b.user_id = u.id
                  AND b.user_id = $1 AND u.active = true AND b.active = true
                  order by  last_move_date desc LIMIT 1;`;
  const result = await pool.query(query,[id]);
  return result.rowCount>0? result.rows[0] : null;
}


exports.saveSession=async (id,token,refresh_token)=>{

  const session = await lastSession(id);

  if(!session){
     const newsession = await registerSession(id,token,refresh_token);
  if(!newsession){
         const error = new Error('User session could not be created');
        error.statusCode = 500;
        error.code = '';
        throw error;
     }
     return newsession;
  }

  const newsession = await updateSession(id,token,refresh_token);
  if(!newsession){
         const error = new Error('User session could not be updated');
        error.statusCode = 500;
        error.code = '';
        throw error;
     }
  return newsession;
}


async function lastSession(id){
  const query = `SELECT * FROM public.session WHERE user_id = $1 AND active = true;`;
  const result = await pool.query(query,[id]);
  return await result.rowCount>0? result.rows[0] : null;
}

async function registerSession(id,token,refresh_token) {
  const query = `INSERT INTO public.session (user_id,token_session,token_refresh) VALUES($1,$2,$3) RETURNING *;`;
  const result = await pool.query(query,[id,token,refresh_token]);
  return result.rowCount>0 ? result.rows[0] : null;
}

async function updateSession(id,token,refresh_token) {
  const query = `UPDATE public.session 
  SET token_session =$1,token_refresh=$2 , registration_date = now()
  WHERE user_id = $3 RETURNING *; `;
  const result = await pool.query(query,[token,refresh_token,id]);
  return result.rowCount>0 ? result.rows[0] : null;
}

exports.validRecoveryCodePassword =async (code)=>{
  const query = `SELECT 
                prr.id as password_recovery_request_id,
                prr.notification_password_recovery_id,
                prr.recovery_code,
                prr.sent,
                prr.open_count,
                prr.is_valid,
                u.id as user_id,
                u.name,
                u.last_name,
                u.email,
                u.uuid
                FROM password_recovery_request  as prr
                INNER JOIN public.user as u
                ON prr.user_id =u.id
  WHERE sent = $1 AND is_Valid = $2 AND recovery_code = $3 LIMIT 1;`;
  const result = await pool.query(query,[1,true,code]);
  return result.rowCount>0 ? result.rows[0] :null;
}


exports.registerPasswordRecoveryQuery = async (item)=>{
  const query = `UPDATE public.password_recovery_request
  SET open_count = open_count+1, 
  first_opened_at = CASE WHEN open_count = 0 THEN now() ELSE first_opened_at END,
  last_opened_at = now()
  WHERE id = $1`;
  const result =await  pool.query(query,[item.password_recovery_request_id]);
  return result.rowCount>0 ? true:false;

}

exports.invalidateRecoveryCodePassword = async (id) => {
  const query = `UPDATE public.password_recovery_request
  SET is_valid = false,
      sent = 0,
      last_opened_at = now()
  WHERE id = $1 RETURNING *;`;
  const result = await pool.query(query, [id]);
  return result.rowCount > 0 ? result.rows[0] : null;
};


exports.getUserBalance = async (id) =>{
  const query = `SELECT 
                  b.id as balance_id,
                  b.user_id,
                  b.balance_amount as balance,
                  b.last_move_date,
                  g.name as group_name,
                  g.company_name,
                  g.address
                  FROM  public.balance as b
                  INNER JOIN public.group as g
                  ON b.group_id = g.id
                  WHERE b.user_id = $1 AND b.active = $2 AND b.balance_amount >0`;
  const result = await pool.query(query,[id,true]);
  return result.rowCount>0 ? result.rows : [];
}

exports.deleteUserBalance = async (id) =>{
  const query =`UPDATE public.balance SET active = $1 WHERE user_id = $2 AND active =$3 RETURNING *;`;
  const result = await pool.query(query,[false,id,true]);
  return result.rowCount>0? true:false;
}

exports.deleteAccountUser = async (id) =>{
  const query = `UPDATE public.user SET active = $1 WHERE id =$2 AND active =$3 RETURNING *;`;
  const result = await pool.query(query,[false,id,true]);
  return result.rowCount>0 ? result.rows[0] : null;
}

exports.confirmemailuser = async (userid,email) =>{
  const query = `UPDATE public.user SET email_is_valid = $1 WHERE id = $2 AND email = $3 RETURNING *;`;
  const result = await pool.query(query,[true,userid,email]);
  return result.rowCount>0? true:false;
}


exports.changecustomerdetailsinvoice =async (saleid,newData) =>{
  const query = `UPDATE public.invoice 
  SET user_payload = $1,
  status_code_invoice =$2
  WHERE sale_id = $3 RETURNING *;`;
  const result = await pool.query(query,[newData,0,saleid]);
  return result.rowCount>0? result.rows[0] : null;
}
const pool = require("../database/pg");

exports.getBalanceMovement = async () => {
  return await getMovement();
};

async function getMovement() {
  const query = `
          SELECT 
            bm.id as balance_movement_id,
            bm.group_id,
            bm.station_id,
            bm.user_id,
            bm.amount,
            bm.balance_movement_type_id,
			      bmt.movement,
            bm.synchronized,
            bm.uuid as balance_movement_uuid,
            bm.reference_uuid
            FROM public.balance_movement as bm
            INNER JOIN type.balance_movement as bmt
            ON bm.balance_movement_type_id = bmt.id
            WHERE synchronized = false;`;
  const result = await pool.query(query);
  return result.rowCount > 0 ? result.rows : [];
}

exports.syncMovementRecharge = async (item)=>{
  let queryMovement = null;
  let transactionFee = 0;
  const query = `SELECT id FROM public.balance WHERE group_id = $1 AND user_id = $2 LIMIT 1;`;

  const resultExists = await pool.query(query, [item.group_id, item.user_id]);
  if (resultExists.rowCount > 0) {

    // const paymentRequest = await findPaymentRequestByUUID(item.reference_uuid);
    // if(!paymentRequest){
    //   console.error(`No hay relación con solicitud de pago para la referencia uuid: ${item.reference_uuid}`);
    //   return;
    // }

    //transactionFee = await findTransactionFeeGroup(paymentRequest);

    queryMovement = `UPDATE public.balance 
    SET balance_amount = balance_amount + $3, last_move_date = now() 
    WHERE group_id = $1 AND user_id = $2 RETURNING *;`;
  } else {
    queryMovement = `INSERT INTO public.balance (group_id,user_id,balance_amount,last_move_date)
    VALUES($1,$2,$3,now()) RETURNING *;`;
  }

  const result = await pool.query(queryMovement, [
    item.group_id,
    item.user_id,
    (item.amount),
  ]);
  return result.rowCount > 0 ? true: false;
}


async function findPaymentRequestByUUID(uuid){
  const query = `SELECT * FROM public.payment_request WHERE uuid = $1 LIMIT 1;`
  const result = await pool.query(query,[uuid]);
  return result.rowCount>0? result.rows[0]: null;
}

async function findTransactionFeeGroup(payload){
  const query = `SELECT * FROM public.group_payment_gateway 
  WHERE group_id = $1 AND  payment_gateway_id = $2 LIMIT 1;`
  const result = await pool.query(query,[payload.group_id, payload.payment_gateway_id]);
  return result.rowCount>0? result.rows[0]['transaction_fee'] : 0;
}




exports.syncMovementPurchase = async (item)=>{
  let queryMovement = null;
  const query = `SELECT id FROM public.balance WHERE group_id = $1 AND user_id = $2 LIMIT 1;`;

  const resultExists = await pool.query(query, [item.group_id, item.user_id]);
  if (resultExists.rowCount > 0) {
    queryMovement = `UPDATE public.balance 
    SET balance_amount = balance_amount - $3, last_move_date = now() 
    WHERE group_id = $1 AND user_id = $2 RETURNING *;`;
  } else {
    queryMovement = `INSERT INTO public.balance (group_id,user_id,balance_amount,last_move_date)
    VALUES($1,$2,$3,now()) RETURNING *;`;
  }

  const result = await pool.query(queryMovement, [
    item.group_id,
    item.user_id,
    item.amount,
  ]);
  return result.rowCount > 0 ? true: false;
}

exports.syncMovementRetained = async (item)=>{
  let queryMovement = null;
  const query = `SELECT id FROM public.balance WHERE group_id = $1 AND user_id = $2 LIMIT 1;`;

  const resultExists = await pool.query(query, [item.group_id, item.user_id]);
  if (resultExists.rowCount > 0) {
    queryMovement = `UPDATE public.balance 
    SET balance_amount = balance_amount - $3, last_move_date = now() 
    WHERE group_id = $1 AND user_id = $2 RETURNING *;`;
  } else {
    queryMovement = `INSERT INTO public.balance (group_id,user_id,balance_amount,last_move_date)
    VALUES($1,$2,$3,now()) RETURNING *;`;
  }

  const result = await pool.query(queryMovement, [
    item.group_id,
    item.user_id,
    item.amount,
  ]);
  return result.rowCount > 0 ? true: false;
}

exports.syncMovementReturn = async (item)=>{
  let queryMovement = null;
  const query = `SELECT id FROM public.balance WHERE group_id = $1 AND user_id = $2 LIMIT 1;`;

  const resultExists = await pool.query(query, [item.group_id, item.user_id]);
  if (resultExists.rowCount > 0) {
    queryMovement = `UPDATE public.balance 
    SET balance_amount = balance_amount + $3, last_move_date = now() 
    WHERE group_id = $1 AND user_id = $2 RETURNING *;`;
  } else {
    queryMovement = `INSERT INTO public.balance (group_id,user_id,balance_amount,last_move_date)
    VALUES($1,$2,$3,now()) RETURNING *;`;
  }

  const result = await pool.query(queryMovement, [
    item.group_id,
    item.user_id,
    item.amount,
  ]);
  return result.rowCount > 0 ? true: false;
}

exports.confirmMovement = async (item)=>{
  const query = `UPDATE public.balance_movement  
  SET synchronized = true, registration_date = now() WHERE id = $1;`;
  const result = await pool.query(query,[item.balance_movement_id]);
  return result.rowCount>0? result.rows[0] : null;
}




exports.getListPendingRecoveryPassword = async() =>{
  const query = `
                SELECT 
                prr.id password_recovery_request_id,
                prr.recovery_code,
                prr.sent,
                prr.request_url,
                prr.open_count,
                prr.is_valid,
                u.id as user_id,
                u.name,
                u.last_name,
                u.email,
                u.phone_number,
                u.uuid,
                npr.notification,
                npr.code
                FROM  password_recovery_request as prr
                INNER JOIN public.user as u
                ON prr.user_id = u.id
                INNER JOIN  type.notification_password_recovery as npr
                ON npr.id = prr.notification_password_recovery_id
                WHERE u.active = $1 AND notification_password_recovery_id = $2 AND sent = $3 AND is_valid =$4;`;
  const result = await pool.query(query,[true,1,0,true]);
  return result.rowCount>0? result.rows : [];
}


exports.confirmSendingEmail = async (isSent,user,code,url)=>{
  const codeSent = isSent ? 1:2;

  const query = `UPDATE public.password_recovery_request 
  SET sent = $1, recovery_code = $2, request_url = $3 ,created_at = now()
  WHERE id = $4 RETURNING *;`;
  const result = await pool.query(query,[codeSent,code,url,user.password_recovery_request_id])
  return result.rowCount>0 ? result.rows[0]:null;
}




exports.getListRecoveryUrl =async ()=>{
  const query = `SELECT * FROM public.password_recovery_request 
  WHERE sent = $1 AND is_valid = $2 AND (created_at < NOW() - INTERVAL '3 minutes' OR open_count >2);`;
  const result = await pool.query(query,[1,true]);
  return result.rowCount>0 ?result.rows : [];
}

exports.disableItemRecovery = async (item) =>{
  const query = `UPDATE public.password_recovery_request SET is_valid = $1
  WHERE id = $2 AND is_valid =true RETURNING *;`;
  const result = await pool.query(query,[false,item.id]);
  return result.rowCount >0 ? result.rows[0] : null;
}

exports.getListReleaseProgramming = async()=>{
  const query = `SELECT * FROM public.programming WHERE programming_status_id IN (0,1,6)
  AND (registration_date < NOW() - INTERVAL '2 minutes')`;
  const result = await pool.query(query,);
  return result.rowCount>0 ?result.rows : [];
}

exports.releaseProgramming = async (item) =>{
  const query = `UPDATE public.programming SET programming_status_id = $1, 
  registration_date = now()
  WHERE id = $2 RETURNING *;`;
  const result = await pool.query(query,[5,item.id]);
  return result.rowCount >0 ? result.rows[0] : null;
}

exports.getListNotifications =async ()=>{
  const query = `SELECT * FROM public.notification WHERE synchronized = $1 AND active = $2 LIMIT 10;`;
  const result = await pool.query(query,[false,true]);
  return result.rowCount>0 ?result.rows : [];
} 


exports.sendNotification = async(item)=>{
  const query = 'UPDATE public.notification SET synchronized = $1, registration_date = now() WHERE id = $2 RETURNING *;';
  const result = await pool.query(query,[true,item.id]);
}



exports.getSaleCompleted = async()=>{
  const query = `SELECT s.id as sale_id,
                  s.price,
                  s.money,
                  s.volume,
                  s.power,
                  s.initial_date_sale,
                  s.final_date_sale,
                  u.id as user_id,
                  u.name,
                  u.last_name,
                  u.email,
                  u.phone_number
                  FROM public.sale as s
                  INNER JOIN public.programming as pg
                  ON s.programming_uuid = pg.uuid
                  INNER JOIN public.user as u
                  ON pg.user_id = u.id
              WHERE notified = $1;`;
  const result = await pool.query(query,[false]);
  return result.rowCount>0 ? result.rows : [];
}

exports.confirmNotificationSending = async(sale)=>{
  const query =`UPDATE public.sale SET notified = $1, notified_at = now() WHERE id = $2 RETURNING *;`;
  const result = await pool.query(query,[true,sale.sale_id]);
  return result.rowCount>0 ? true:false;
}


exports.getListNotifyEmail = async()=>{
  const query = `SELECT * FROM public.user WHERE email_is_valid = $1 AND email_notified = $2 LIMIT 1`;
  const result = await pool.query(query,[false,false]);
  return result.rowCount>0 ? result.rows :[];
}


exports.confirmSendingEmailUser = async (user)=>{
  const query = `UPDATE public.user SET email_notified = $1, notified_at = now() WHERE id = $2 RETURNING *;`;
  const result = await pool.query(query,[true ,user.id]);
  return result.rowCount>0 ? true :false;
}

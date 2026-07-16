const userRepository = require("./user.repository");
const bcrypt = require("bcrypt");
const { jwt_user, jwt_refresh_user } = require("../../helpers/jwt");
const { env } = require("../../config/env");
const pool = require("../../database/pg");
const jwt = require("jsonwebtoken");
exports.register = async (data) => {
  data.password = await createHash(data.password);
  return await userRepository.register(data);
};

exports.edit = async (id, data) => {
  return await userRepository.edit(id, data);
};

exports.termsconditions = async (id) => {
  return await userRepository.termsconditions(id);
};
exports.registertermsconditions = async (data) => {
  return await userRepository.registertermsconditions(data);
};
exports.changepassword = async (id, data) => {
  data.password = await createHash(data.password);
  return await userRepository.changepassword(id, data);
};

exports.passwordrecoveryurl = async (code, request) => {
  if (!code) {
    const error = new Error("recovery code is required");
    error.statusCode = 400;
    error.code = "";
    throw error;
  }

  const protocol = request.protocol || "https";
  const host = request.get("host");
  const baseUrl = `${protocol}://${host}`;
  const url = `${baseUrl}/public/recover-password.html?code=${encodeURIComponent(code)}`;

  return {
    code,
    url,
  };
};

exports.validtokenrefresh = async (t) => {
  const isValid = jwt.verify(t, env.refreshsecret);
  if (!isValid) {
    const error = new Error("refresh token is invalid");
    error.statusCode = 401;
    error.code = "";
    throw error;
  }

  const sessionToken = await findTokenSession(t);

  const user = await findUserTokenSession(t);
  if(!user){
    const error = new Error("User information not found");
    error.statusCode = 401;
    error.code = "";
    throw error;
  }
  
  if(!user.email_is_valid){
    const error = new Error("The user has not confirmed the email address.");
    error.statusCode = 401;
    error.code = "";
    throw error;
  }

  const vehicles = await userRepository.getVehiclesById(user.id);
  const balance = await userRepository.getBalanceById(user.id);

  const user_token = {
    id: user.id,
    rol: "user",
    identifier: user.email,
  };

  const token = jwt_user(user_token);
  //const token = sessionToken.token_session;
  const refresh_token = sessionToken.token_refresh;
  await userRepository.saveSession(user.id, token, refresh_token);

  return {
    info: {
      user,
      balance,
      vehicles,
    },
    token,
    refresh_token,
  };
};

async function findTokenSession(token) {
  const query = `SELECT * FROM  public.session as s
                WHERE s.active = true AND token_refresh = $1 LIMIT 1;`;
  const result = await pool.query(query, [token]);
  return result.rowCount > 0 ? result.rows[0] : null;
}

async function findUserTokenSession(token) {
  const query = `SELECT u.* FROM  public.session as s
                INNER JOIN public.user as u
                ON s.user_id = u.id
                WHERE s.active = true AND u.active = true AND token_refresh = $1 LIMIT 1;`;
  const result = await pool.query(query, [token]);
  return result.rowCount > 0 ? result.rows[0] : null;
}

exports.authentication = async (data) => {
  const user = await userRepository.getUserByEmail(data.email);
  if (!user) {
    const error = new Error("user does not exist");
    error.statusCode = 401;
    error.code = "";
    throw error;
  }

  if(!user.email_is_valid){
    const error = new Error("The user has not confirmed the email address.");
    error.statusCode = 401;
    error.code = "";
    throw error;
  }

  const isValid = await bcrypt.compare(data.password, user.key_hash);
  if (!isValid) {
    const error = new Error("invalid password");
    error.statusCode = 401;
    error.code = "";
    throw error;
  }
  const vehicles = await userRepository.getVehiclesById(user.id);
  const balance = await userRepository.getBalanceById(user.id);
  const user_token = {
    id: user.id,
    rol: "user",
    identifier: user.email,
  };

  const token = jwt_user(user_token);
  const refresh_token = jwt_refresh_user(user_token);

  await userRepository.saveSession(user.id, token, refresh_token);

  return {
    info: {
      user,
      balance,
      vehicles,
    },
    token,
    refresh_token,
  };
};

async function createHash(pass) {
  const password = pass;
  const hash = await bcrypt.hash(password, 10);
  console.log(hash);
  return hash;
}

exports.passwordrecoverybyemail = async (email) => {
  const uservalid = await validateEmail(email);
  if (!uservalid) {
    const error = new Error("email does not exist");
    error.statusCode = 404;
    error.code = "";
    throw error;
  }

  const recoveryRequest = await createRecoveryRequest(uservalid);
  if (!recoveryRequest) {
    const error = new Error("could not create recovery request");
    error.statusCode = 500;
    error.code = "";
    throw error;
  }

  return recoveryRequest;
};

async function validateEmail(email) {
  const query = `SELECT * FROM public.user WHERE TRIM(email) = $1 LIMIT 1;`;
  const result = await pool.query(query, [email]);
  return result.rowCount > 0 ? result.rows[0] : null;
}

async function createRecoveryRequest(user) {
  let query = null;
  const pendingRequestQuery = `SELECT id FROM public.password_recovery_request  
  WHERE user_id = $1;`;
  const result0 = await pool.query(pendingRequestQuery, [user.id]);

  if (result0.rowCount > 0) {
    query = `UPDATE public.password_recovery_request 
    SET sent =0,
        open_count = $1,
        is_valid =$2,
        notification_password_recovery_id = $3,
        created_at = now()
    WHERE user_id = $4 RETURNING *;`;
  } else {
    query = `INSERT INTO public.password_recovery_request (open_count,is_valid,notification_password_recovery_id,user_id)
    VALUES ($1,$2,$3,$4) RETURNING *;`;
  }
  const resutl = await pool.query(query, [0, true, 1, user.id]);
  return resutl.rowCount > 0 ? resutl.rows[0] : null;
}

exports.validRecoveryCodePassword = async (code) => {
  const isValid = await userRepository.validRecoveryCodePassword(code);
  if (!isValid) {
    const error = new Error("recovery code is invalid");
    error.statusCode = 404;
    error.code = "";
    throw error;
  }
  await userRepository.registerPasswordRecoveryQuery(isValid);

  return isValid;
};

exports.passwordrecoveryupdate = async (data) => {
  if (!data?.email || !data?.password || !data?.code) {
    const error = new Error("email, password and code are required");
    error.statusCode = 400;
    error.code = "";
    throw error;
  }

  const recoveryRequest = await userRepository.validRecoveryCodePassword(data.code);
  if (!recoveryRequest) {
    const error = new Error("recovery code is invalid");
    error.statusCode = 404;
    error.code = "";
    throw error;
  }

  if (recoveryRequest.email.trim() !== data.email.trim()) {
    const error = new Error("recovery email does not match");
    error.statusCode = 400;
    error.code = "";
    throw error;
  }

  const hashedPassword = await createHash(data.password);
  const updatedUser = await userRepository.changepassword(recoveryRequest.user_id, {
    password: hashedPassword,
  });

  if (!updatedUser) {
    const error = new Error("password could not be updated");
    error.statusCode = 500;
    error.code = "";
    throw error;
  }

  console.log("[password-recovery-update]", {
    email: data.email,
    code: data.code,
    password: "[hashed]",
  });

  await userRepository.invalidateRecoveryCodePassword(
    recoveryRequest.password_recovery_request_id
  );

  return {
    received: true,
    email: data.email,
    user_id: recoveryRequest.user_id,
  };
};


exports.deleteaccount =async (userid) =>{
  const balance= await userRepository.getUserBalance(userid);
  if(balance.length>0){
    await userRepository.deleteUserBalance(userid);
  }

  const user = await userRepository.deleteAccountUser(userid);

  return {user ,balance};
}


exports.confirmemailuser =async (userid,email) =>{
  return await userRepository.confirmemailuser(userid,email);

}



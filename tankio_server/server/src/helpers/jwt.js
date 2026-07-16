const jwt = require("jsonwebtoken");
const {env} = require('../config/env');

function jwt_payload(data) {
  return {
    sub: data.id,
    role: data.rol,
    identifier: data.identifier,
  };
}

exports.jwt_controller = (module) => {
  const payload = jwt_payload(module);
  return jwt.sign(payload, env.jwtsecret, { expiresIn: "30d" });
};

exports.jwt_screen = (screen) => {
  const payload = jwt_payload(screen);
  return jwt.sign(payload, env.jwtsecret, { expiresIn: "30d" });
};

exports.jwt_user = (user) => {
  const payload = jwt_payload(user);
  return jwt.sign(payload, env.jwtsecret, { expiresIn: "1h" });
};

exports.jwt_refresh_user = (user) => {
  const payload = jwt_payload(user);
  return jwt.sign(payload, env.refreshsecret, { expiresIn: "30d" });
};

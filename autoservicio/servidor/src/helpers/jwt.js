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

exports.jwtscreen = (screen) => {
  const payload = jwt_payload(screen);
  return jwt.sign(payload, env.jwtsecret, { expiresIn: "30d" });
};


exports.jwtterminal = (screen) => {
  const payload = jwt_payload(screen);
  return jwt.sign(payload, env.jwtsecret, { expiresIn: "30d" });
};

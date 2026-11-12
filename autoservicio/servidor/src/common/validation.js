const { createHttpError } = require('./http-error');

function requirePositiveIntegerParam(value, fieldName) {
  if (!/^\d+$/.test(String(value ?? ''))) {
    throw createHttpError(400, `INVALID_${fieldName.toUpperCase()}`, `${fieldName} must be a valid integer`);
  }

  return Number(value);
}

function requireNonEmptyArray(value, fieldName) {
  if (!Array.isArray(value) || value.length === 0) {
    throw createHttpError(400, `INVALID_${fieldName.toUpperCase()}`, `${fieldName} must be a non-empty array`);
  }

  return value;
}

module.exports = {
  requirePositiveIntegerParam,
  requireNonEmptyArray
};

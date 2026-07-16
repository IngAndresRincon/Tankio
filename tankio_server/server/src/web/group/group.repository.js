const pool = require("../database/pg");
const { createHttpError } = require("../../common/http-error");



exports.getlistgroup = async ()=>{
  const query = `SELECT * FROM public.group;`;
  const result = await pool.query(query);
  return result.rowCount>0 ? result.rows: [];
}

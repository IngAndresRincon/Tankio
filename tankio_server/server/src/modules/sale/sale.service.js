const saleRepository = require('./sale.repository');
const bcrypt = require('bcrypt');
const { jwt_user,jwt_refresh_user} = require('../../helpers/jwt');
const {env} = require('../../config/env');



exports.registersaleinselect = async (data) => {
  return await saleRepository.registersaleinselect(data);
};

exports.getsalebyuser = async (id) => {
  return await saleRepository.getsalebyuser(id);
};

exports.getinvoicebysale = async (saleid) =>{
  const invoice =  await saleRepository.getinvoicebysale(saleid);
  if(invoice){
    invoice.qr =`${env.fe.dian_url_qa}?documentkey=${invoice.response_invoice_payload.cufe}`;
  }

  return invoice;
}


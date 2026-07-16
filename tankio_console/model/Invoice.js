class Invoice{
    constructor(posTransactionId,issueDate,issueTime,currency,supplier,customer,items,payments,note){
        this.posTransactionId = posTransactionId;
        this.issueDate = issueDate;
        this.issueTime = issueTime;
        this.currency = currency;
        this.supplier = supplier;
        this.customer = customer;
        this.items = items;
        this.payments = payments;
        this.note = note;
    }
}


class Supplier{
    constructor(nit,dv,name){
        this.nit = nit;
        this.dv = dv;
        this.name = name;
    }
}

class Customer{
    constructor(nit,documentTypeCode,name,email,departmentCode,cityCode,cityName){
        this.nit = nit;
        this.documentTypeCode = documentTypeCode;
        this.name = name;
        this.email = email;
        this.departmentCode = departmentCode;
        this.cityCode = cityCode;
        this.cityName = cityName;
    }
}


class Items{
    constructor(id,sku,description,qty,unitCode,unitPrice,lineSubtotalAmount,lineTotalAmount,taxes){
        this.id = id;
        this.sku = sku;
        this.description = description;
        this.qty = qty;
        this.unitCode = unitCode;
        this.unitPrice = unitPrice;
        this.lineSubtotalAmount = lineSubtotalAmount;
        this.lineTotalAmount = lineTotalAmount;
        this.taxes = taxes;
    }
}

class Taxes{
    constructor(schemeId,percent,taxTreatment){
        this.schemeId = schemeId;
        this.percent = percent;
        this.taxTreatment = taxTreatment;
    }
}

class Payments{
    constructor(paymentForm,paymentMethod,amount){
        this.paymentForm = paymentForm;
        this.paymentMethod = paymentMethod;
        this.amount = amount;
    }
}

async function GenerateItemInvoice(record){

}

module.exports = {GenerateItemInvoice,Supplier,Customer};
//Rechnung generieren
const PDFDocument = require('pdfkit');
const fs = require('fs');

function generateInvoice(payment, operator) {
  const doc = new PDFDocument();
  const fileName = `invoice_${payment.id}.pdf`;
  doc.pipe(fs.createWriteStream(fileName));

  doc.fontSize(20).text('ChickenTruckApp – Rechnung', { align: 'center' });
  doc.moveDown();
  doc.fontSize(12).text(`Betreiber: ${operator.company_name}`);
  doc.text(`Betrag: ${payment.amount} EUR`);
  doc.text(`Datum: ${new Date(payment.paid_at).toLocaleDateString()}`);
  doc.text(`Paket: ${payment.package_id}`);
  doc.end();

  return fileName;
}

module.exports = generateInvoice;

//E-Mail-Versand
const nodemailer = require('nodemailer');

async function sendInvoiceEmail(to, filePath) {
  const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
      user: 'deine.email@gmail.com',
      pass: 'deinAppPasswort'
    }
  });

  await transporter.sendMail({
    from: 'ChickenTruckApp <deine.email@gmail.com>',
    to,
    subject: 'Ihre Monatsrechnung',
    text: 'Im Anhang finden Sie Ihre Rechnung.',
    attachments: [{ path: filePath }]
  });
}

module.exports = sendInvoiceEmail;

//Benachrichtigung bei Paketablauf
//Beispiel-Skript:
// In einem Cronjob oder beim Login prüfen
const { data: payments } = await supabase
  .from('payments')
  .select('*')
  .eq('recurring', true);

payments.forEach(payment => {
  const paidDate = new Date(payment.paid_at);
  const nextDue = new Date(paidDate);
  nextDue.setDate(paidDate.getDate() + 7 * payment.duration_weeks);

  if (nextDue - new Date() < 3 * 24 * 60 * 60 * 1000) {
    // Sende Erinnerung
    sendInvoiceEmail(payment.operator_email, 'Ihr Paket läuft bald ab...');
  }
});

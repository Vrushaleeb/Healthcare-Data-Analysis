-- CREATE DATABASE 
Use Healthcare;

-- RETRIEVE ALL TABLE INFORMATION
SELECT * FROM patients;
SELECT * FROM appointments;
SELECT * FROM billing;
SELECT * FROM doctors;
SELECT * FROM prescriptions;

SELECT * FROM patients, appointments, billing, doctors, prescriptions;

-- GET ALL APPPOINTMENTS FOR A SPECIFIC PATIENT
SELECT * FROM Appointments 
WHERE patient_id=1;

-- RETRIEVE ALL PRESCRIPTIONS FOR A SPECIFIC APPOINTMENT
SELECT * FROM prescriptions
WHERE appointment_id=1;

-- GET BILLING INFORMATION FOR A SPECIFIC APPOINTMENT
SELECT * FROM Billing
WHERE appointment_id=2;

SELECT a.appointment_id, p.first_name AS patient_first_name, p.last_name AS patient_last_name,
d.first_name AS doctor_first_name, d.last_name AS doctor_last_name,
a.appointment_date, a.reason
FROM appointments a
JOIN Patients p ON a.patient_id=p.patient_id
JOIN Doctors d ON a.doctor_id= d.doctor_id;

-- LIST ALL APPOINTMENTS WITH BILLING STATUS
SELECT a.appointment_id, p.first_name AS patient_first_name, p.last_name AS patient_last_name,
d.first_name AS doctor_first_name, d.last_name AS doctor_last_name,
b.amount, b.payment_date, b.status
FROM appointments a
JOIN Patients p ON a.patient_id=p.patient_id
JOIN Doctors d ON a.doctor_id= d.doctor_id
JOIN Billing b ON a.appointment_id= b.appointment_id;

-- FIND ALL PAID BILLLING
SELECT * FROM Billing 
WHERE status ='Paid';

-- CALCULATE TOTAL AMOUNT BILLED AND TOTAL PAID AMOUNT
SELECT
(SELECT SUM(amount) FROM Billing) AS total_billed,
(SELECT SUM(amount) FROM Billing WHERE status='Paid') AS total_paid;

-- GET THE NUMBER OF APPOINTMENTS BY SPECIALTY
SELECT d.specialty, COUNT(a.appointment_id) AS number_of_appointments
FROM appointments a
JOIN doctors d ON a.doctor_id=d.doctor_id
GROUP BY d.specialty;

-- FIND THE MOST COMMON REASON FOR APPOINTMENTS
SELECT reason,
COUNT(*) AS count
FROM appointments
GROUP BY reason
ORDER BY count DESC;

-- LIST PATIENTS WITH THEIR LATEST APPOINTMENT DATE
SELECT p.patient_id, p.first_name, p.last_name, MAX(a.appointment_date) AS latest_appointment
FROM patients p
JOIN Appointments a ON p.patient_id=a.patient_id
GROUP BY p.patient_id, p.first_name, p.last_name;

-- LIST ALL DOCTORS AND THE NUMBER OF APPOINTMENTS THEY HAD
SELECT d.doctor_id, d.first_name, d.last_name, COUNT(a.appointment_id) AS number_of_appointments
FROM doctors d
LEFT JOIN Appointments a ON d.doctor_id=a.doctor_id
GROUP BY d.doctor_id, d.first_name, d.last_name;

-- RETRIEVE PATIENTS WHO HAD APPOINTMENTS IN THE LAST 30 DAYS
SELECT DISTINCT p.*
FROM patients p
JOIN appointments a ON p.patient_id=a.patient_id
WHERE a.appointment_date>=CURDATE()-INTERVAL 30 DAY;

-- FIND PRESCRIPTION ASSCOCIATED WITH APPOINTMENTS THAT ARE PENDING PAYMENT
SELECT pr.prescription_id, pr.medication, pr.dosage, pr.instructions
FROM prescriptions pr
JOIN appointments a ON pr.appointment_id=a.appointment_id
JOIN Billing b ON a.appointment_id=b.appointment_id
WHERE b.status='Pending';

-- ANALYSE PATIENT DEMOGRAPHICS
SELECT gender, COUNT(*) AS count
FROM patients
GROUP BY gender;

-- ANALYZE THE TREND OF APPOINTMENT OVER MONTHS OR YEARS
SELECT DATE_FORMAT(appointment_date, '%Y-%m') AS month, COUNT(*) AS number_of_appointments
FROM Appointments
GROUP BY month
ORDER BY month;

-- YEARLY TREND
SELECT YEAR(appointment_date) AS year, COUNT(*) AS number_of_appointments
FROM Appointments
GROUP BY year
ORDER BY year;

-- IDENTIFY THE MOST FREQUENTLY PRESCRIBED MEDICATIONS AND THEIR TOTAL DOSAGE
SELECT medication, COUNT(*) AS frequency, SUM(CAST(SUBSTRING_INDEX(dosage, '',1) AS UNSIGNED)) AS total_dosage
FROM Prescriptions
GROUP BY medication
ORDER BY frequency DESC;

-- AVERAGE BILLING AMOUNT BY NUMBER OF APPOINTMENTS
SELECT p.patient_id, COUNT(a.appointment_id) AS appointment_count, AVG(b.amount) AS Avg_billing_amount
FROM patients p
LEFT JOIN Appointments a ON p.patient_id= A.PATIENT_id
LEFT JOIN Billing b on a.appointment_id=b.appointment_id
GROUP BY p.patient_id;

-- ANALYZE THE CORRELATION BETWEEN APPOINTMENT FREQUENCY AND BILLING STATUS
SELECT p.patient_id, p.first_name, p.last_name, SUM(b.amount) AS total_billed
FROM patients p
JOIN Appointments a ON p.patient_id= a.patient_id	
JOIN billing b ON a.appointment_id=b.appointment_id
GROUP BY p.patient_id, p.first_name, p.last_name
ORDER BY total_billed DESC
LIMIT 10;

-- PAYMENT STATUS OVER TIME
SELECT DATE_FORMAT(payment_date, '%Y-%m') AS month, status, COUNT(*) AS count
FROM billing
GROUP BY month, status
ORDER By month, status;

-- UNPAID BILLS ANALYSIS
SELECT p.patient_id, p.first_name, p.last_name, SUM(b.amount) AS total_unpaid
FROM patients p
JOIN appointments a ON p.patient_id= a.patient_id
JOIN billing b ON a.appointment_id=b.appointment_id
WHERE b.status='Pending'
GROUP BY p.patient_id, p.first_name, p.last_name
ORDER BY total_unpaid DESC;

-- DOCTOR PERFORMANCE METRICS
SELECT d.doctor_id, d.first_name, d.last_name, Count(a.appointment_id) AS number_of_appointment
FROM Doctors d
LEFT JOIN  appointments a ON d.doctor_id= a.doctor_id
GROUP BY d.doctor_id, d.first_name, d.last_name;

-- DAY WISE APPOINTMENT COUNTS
SELECT appointment_date, COUNT(*) AS appointment_count
FROM appointments
GROUP BY appointment_date;

-- FIND PATIENTS WITH MISSING APPOINTMENTS 
SELECT p.patient_id, p.first_name, p.last_name
FROM Patients p
LEFT JOIN Appointments a ON p.patient_id= a.patient_id
WHERE a.appointment_id IS NULL;

-- FIND APPOINTMENTS WITHOUT BILLING RECORDS
SELECT a.appointmnet_id, a.patient_id, a.doctor_id, a.appointment_date 
FROM Appointments a
LEFT JOIN billing b ON a.apointment_id =b.appointmnet_id
WHERE b.billing IS NULL;

-- FIND ALL APPOINTMENT FOR DOCTOR WITH ID 1
SELECT a.appointment_id, p.first_name AS patient_first_name, p.last_name AS patient_last_name, a.appointment_date, a.reason
FROM appointments a
JOIN Patients p ON a.patient_id=p.patient_id
WHERE a.doctor_id=1;

-- ALL PRESCRIPTIONS WITH PAYMENT STATUS AS PENDING
SELECT p.medication, p.dosage, p. instructions, b.amount, b.payment_date, b.status
FROM prescriptions p
JOIN appointments a ON p.appointment_id= a.appointment_id
JOIN billing b ON a.appointment_id=b.appointment_id
WHERE b.status='Pending';

-- LIST ALL PATIENTS WHO HAD APPOINTMNETS IN AUGUST
SELECT DISTINCT p.first_name, p.last_name, p.dob, p.gender, a.appointment_date
FROM patients p
JOIN appointments a ON p.patient_id= a.patient_id
WHERE DATE_FORMAT (a.appointment_date, '%Y-%m')='2024-08';

-- LIST ALL DOCTORS AND THEIR APPOINTMENTS IN AUGUST TILL TODAY
SELECT d.first_name, d.last_name, a.appointment_date, p.first_name AS Patient_first_Name, p.last_name AS patient_last_name
FROM doctors d
JOIN appointments a ON d.doctor_id=a.doctor_id
JOIN patients p ON a.patient_id= p.patient_id
WHERE a.appointment_date BETWEEN '2024-08-01' AND '2024-08-10';

-- GET TOTAL AMOUNT BILLED PER DOCTOR
SELECT d.first_name,d.last_name,d.specialty,SUM(b.amount) AS total_billed 
FROM doctors d
JOIN appointments a ON d.doctor_id=a.doctor_id
JOIN billing b ON a.appointment_id=b.appointment_id
GROUP BY d.first_name, d.last_name, d.specialty
ORDER BY total_billed DESC;
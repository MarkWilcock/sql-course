-- This script creates a temporary table #PatientStay and fills it with data.
-- It can be run on any SQL Server database, even without access to the original PatientStay table.

DROP TABLE IF EXISTS #PatientStay;

CREATE TABLE #PatientStay (
    [PatientId] [int] NOT NULL PRIMARY KEY,
    [AdmittedDate] [date] NOT NULL,
    [Hospital] [varchar](50) NOT NULL,
    [Ward] [varchar](50) NOT NULL,
    [Tariff] [float] NOT NULL,
    [Ethnicity] [varchar](50) NULL,
    [DischargeDate] [date] NULL
);

INSERT INTO #PatientStay (PatientId, AdmittedDate, Hospital, Ward, Tariff, Ethnicity, DischargeDate) VALUES (1, '2024-02-26', 'Kingston', 'Dermatology', 2, 'White', '2024-03-04');
INSERT INTO #PatientStay (PatientId, AdmittedDate, Hospital, Ward, Tariff, Ethnicity, DischargeDate) VALUES (2, '2024-02-26', 'Kingston', 'Ophthalmology', 8, 'Black British', '2024-02-27');
INSERT INTO #PatientStay (PatientId, AdmittedDate, Hospital, Ward, Tariff, Ethnicity, DischargeDate) VALUES (3, '2024-02-26', 'PRUH', 'Day Surgery', 4, 'Asian', '2024-02-28');
INSERT INTO #PatientStay (PatientId, AdmittedDate, Hospital, Ward, Tariff, Ethnicity, DischargeDate) VALUES (4, '2024-02-26', 'Oxleas', 'Dermatology', 8, NULL, '2024-03-06');
INSERT INTO #PatientStay (PatientId, AdmittedDate, Hospital, Ward, Tariff, Ethnicity, DischargeDate) VALUES (5, '2024-02-26', 'Oxleas', 'Ophthalmology', 5, 'White', '2024-02-28');
INSERT INTO #PatientStay (PatientId, AdmittedDate, Hospital, Ward, Tariff, Ethnicity, DischargeDate) VALUES (6, '2024-02-26', 'Oxleas', 'Day Surgery', 8, 'Black British', '2024-02-28');
INSERT INTO #PatientStay (PatientId, AdmittedDate, Hospital, Ward, Tariff, Ethnicity, DischargeDate) VALUES (7, '2024-02-26', 'Kings College', 'Dermatology', 10, 'Asian', '2024-03-02');
INSERT INTO #PatientStay (PatientId, AdmittedDate, Hospital, Ward, Tariff, Ethnicity, DischargeDate) VALUES (8, '2024-02-26', 'Kings College', 'Ophthalmology', 1, NULL, '2024-03-05');
INSERT INTO #PatientStay (PatientId, AdmittedDate, Hospital, Ward, Tariff, Ethnicity, DischargeDate) VALUES (9, '2024-02-26', 'Kings College', 'Day Surgery', 6, 'White', '2024-03-05');
INSERT INTO #PatientStay (PatientId, AdmittedDate, Hospital, Ward, Tariff, Ethnicity, DischargeDate) VALUES (21, '2024-02-28', 'Kingston', 'Day Surgery', 2, 'Black British', '2024-03-05');
INSERT INTO #PatientStay (PatientId, AdmittedDate, Hospital, Ward, Tariff, Ethnicity, DischargeDate) VALUES (23, '2024-02-28', 'Oxleas', 'Ophthalmology', 10, NULL, '2024-03-07');
INSERT INTO #PatientStay (PatientId, AdmittedDate, Hospital, Ward, Tariff, Ethnicity, DischargeDate) VALUES (25, '2024-02-28', 'Kings College', 'Dermatology', 5, 'Black British', '2024-03-04');
INSERT INTO #PatientStay (PatientId, AdmittedDate, Hospital, Ward, Tariff, Ethnicity, DischargeDate) VALUES (27, '2024-02-28', 'Kings College', 'Day Surgery', 8, NULL, '2024-03-05');
INSERT INTO #PatientStay (PatientId, AdmittedDate, Hospital, Ward, Tariff, Ethnicity, DischargeDate) VALUES (29, '2024-03-01', 'Kingston', 'Ophthalmology', 4, 'Black British', '2024-03-02');
INSERT INTO #PatientStay (PatientId, AdmittedDate, Hospital, Ward, Tariff, Ethnicity, DischargeDate) VALUES (34, '2024-03-01', 'Kings College', 'Dermatology', 7, 'Asian', '2024-03-07');
INSERT INTO #PatientStay (PatientId, AdmittedDate, Hospital, Ward, Tariff, Ethnicity, DischargeDate) VALUES (35, '2024-03-01', 'Kings College', 'Ophthalmology', 7, NULL, '2024-03-04');
INSERT INTO #PatientStay (PatientId, AdmittedDate, Hospital, Ward, Tariff, Ethnicity, DischargeDate) VALUES (36, '2024-03-01', 'Kings College', 'Day Surgery', 2, 'White', '2024-03-05');
INSERT INTO #PatientStay (PatientId, AdmittedDate, Hospital, Ward, Tariff, Ethnicity, DischargeDate) VALUES (37, '2024-03-02', 'Kingston', 'Dermatology', 1, 'Black British', '2024-03-06');
INSERT INTO #PatientStay (PatientId, AdmittedDate, Hospital, Ward, Tariff, Ethnicity, DischargeDate) VALUES (38, '2024-03-02', 'PRUH', 'Ophthalmology', 8, 'Asian', '2024-03-03');
INSERT INTO #PatientStay (PatientId, AdmittedDate, Hospital, Ward, Tariff, Ethnicity, DischargeDate) VALUES (39, '2024-03-02', 'Kingston', 'Day Surgery', 10, NULL, '2024-03-05');
INSERT INTO #PatientStay (PatientId, AdmittedDate, Hospital, Ward, Tariff, Ethnicity, DischargeDate) VALUES (100, '2024-02-27', 'Kingston', 'General Surgery', 9, 'Black British', '2024-03-05');
INSERT INTO #PatientStay (PatientId, AdmittedDate, Hospital, Ward, Tariff, Ethnicity, DischargeDate) VALUES (110, '2024-02-27', 'PRUH', 'Ophthalmology', 8, 'Asian', '2024-03-02');
INSERT INTO #PatientStay (PatientId, AdmittedDate, Hospital, Ward, Tariff, Ethnicity, DischargeDate) VALUES (120, '2024-02-27', 'Kingston', 'Day Surgery', 6, NULL, '2024-03-01');
INSERT INTO #PatientStay (PatientId, AdmittedDate, Hospital, Ward, Tariff, Ethnicity, DischargeDate) VALUES (130, '2024-02-27', 'Oxleas', 'General Surgery', 8, 'White', '2024-03-05');
INSERT INTO #PatientStay (PatientId, AdmittedDate, Hospital, Ward, Tariff, Ethnicity, DischargeDate) VALUES (140, '2024-02-27', 'Oxleas', 'Ophthalmology', 4, 'Black British', '2024-02-29');
INSERT INTO #PatientStay (PatientId, AdmittedDate, Hospital, Ward, Tariff, Ethnicity, DischargeDate) VALUES (150, '2024-02-27', 'Oxleas', 'Day Surgery', 7, 'Asian', '2024-03-06');
INSERT INTO #PatientStay (PatientId, AdmittedDate, Hospital, Ward, Tariff, Ethnicity, DischargeDate) VALUES (160, '2024-02-27', 'Kings College', 'Dermatology', 7, NULL, '2024-03-05');
INSERT INTO #PatientStay (PatientId, AdmittedDate, Hospital, Ward, Tariff, Ethnicity, DischargeDate) VALUES (170, '2024-02-27', 'Kings College', 'Ophthalmology', 6, 'White', '2024-02-29');
INSERT INTO #PatientStay (PatientId, AdmittedDate, Hospital, Ward, Tariff, Ethnicity, DischargeDate) VALUES (180, '2024-02-27', 'Kings College', 'Day Surgery', 9, 'Black British', '2024-02-29');
INSERT INTO #PatientStay (PatientId, AdmittedDate, Hospital, Ward, Tariff, Ethnicity, DischargeDate) VALUES (190, '2024-02-28', 'Kingston', 'Dermatology', 10, 'Asian', '2024-03-02');
INSERT INTO #PatientStay (PatientId, AdmittedDate, Hospital, Ward, Tariff, Ethnicity, DischargeDate) VALUES (200, '2024-02-28', 'Kingston', 'Ophthalmology', 6, 'White', '2024-03-04');
INSERT INTO #PatientStay (PatientId, AdmittedDate, Hospital, Ward, Tariff, Ethnicity, DischargeDate) VALUES (310, '2024-03-01', 'Oxleas', 'Dermatology', 3, NULL, '2024-03-06');
INSERT INTO #PatientStay (PatientId, AdmittedDate, Hospital, Ward, Tariff, Ethnicity, DischargeDate) VALUES (320, '2024-03-01', 'Oxleas', 'Ophthalmology', 7, 'White', '2024-03-07');
INSERT INTO #PatientStay (PatientId, AdmittedDate, Hospital, Ward, Tariff, Ethnicity, DischargeDate) VALUES (330, '2024-03-01', 'Oxleas', 'Day Surgery', 9, 'Black British', '2024-03-09');
INSERT INTO #PatientStay (PatientId, AdmittedDate, Hospital, Ward, Tariff, Ethnicity, DischargeDate) VALUES (400, '2024-03-02', 'Oxleas', 'Dermatology', 1, 'White', '2024-03-04');
INSERT INTO #PatientStay (PatientId, AdmittedDate, Hospital, Ward, Tariff, Ethnicity, DischargeDate) VALUES (411, '2024-03-02', 'Oxleas', 'Ophthalmology', 9, 'Black British', '2024-03-03');
INSERT INTO #PatientStay (PatientId, AdmittedDate, Hospital, Ward, Tariff, Ethnicity, DischargeDate) VALUES (422, '2024-03-02', 'Oxleas', 'Day Surgery', 2, 'Asian', '2024-03-03');
INSERT INTO #PatientStay (PatientId, AdmittedDate, Hospital, Ward, Tariff, Ethnicity, DischargeDate) VALUES (433, '2024-03-02', 'PRUH', 'Dermatology', 8, NULL, '2024-03-07');
INSERT INTO #PatientStay (PatientId, AdmittedDate, Hospital, Ward, Tariff, Ethnicity, DischargeDate) VALUES (455, '2024-03-02', 'Kings College', 'General Surgery', 7, 'White', '2024-03-05');
INSERT INTO #PatientStay (PatientId, AdmittedDate, Hospital, Ward, Tariff, Ethnicity, DischargeDate) VALUES (2200, '2024-02-28', 'Oxleas', 'Dermatology', 5, 'Asian', '2024-03-01');
INSERT INTO #PatientStay (PatientId, AdmittedDate, Hospital, Ward, Tariff, Ethnicity, DischargeDate) VALUES (2400, '2024-02-28', 'Oxleas', 'Ultrasound', 10, 'White', '2024-02-29');
INSERT INTO #PatientStay (PatientId, AdmittedDate, Hospital, Ward, Tariff, Ethnicity, DischargeDate) VALUES (2600, '2024-02-28', 'Kings College', 'Ophthalmology', 8, 'Asian', '2024-03-01');
INSERT INTO #PatientStay (PatientId, AdmittedDate, Hospital, Ward, Tariff, Ethnicity, DischargeDate) VALUES (2800, '2024-03-01', 'Kingston', 'Dermatology', 7, 'White', '2024-03-02');
INSERT INTO #PatientStay (PatientId, AdmittedDate, Hospital, Ward, Tariff, Ethnicity, DischargeDate) VALUES (3000, '2024-03-01', 'Kingston', 'Ultrasound', 5, 'Asian', '2024-03-04');

SELECT * FROM #PatientStay;
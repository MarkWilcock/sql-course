DROP TABLE IF EXISTS #DimHospital;

CREATE TABLE #DimHospital (
    [Hospital] [varchar](50) NOT NULL,
    [HospitalType] [varchar](50) NOT NULL,
    [HospitalSize] [varchar](50) NOT NULL,
    [Reach] [varchar](50) NOT NULL
);

INSERT INTO #DimHospital ([Hospital], [HospitalType], [HospitalSize], [Reach]) VALUES ('Kings College', 'Teaching', 'Medium', 'City');
INSERT INTO #DimHospital ([Hospital], [HospitalType], [HospitalSize], [Reach]) VALUES ('Kingston', 'General', 'Small', 'County');
INSERT INTO #DimHospital ([Hospital], [HospitalType], [HospitalSize], [Reach]) VALUES ('Oxleas', 'General', 'Medium', 'County');
INSERT INTO #DimHospital ([Hospital], [HospitalType], [HospitalSize], [Reach]) VALUES ('PRUH', 'Teaching', 'Small', 'County');

--problem 1
--common fields between the existing members and members_acquired tables:
--first_name, last_name, email_address, address, zip_code
 
--problem 2
CREATE TABLE members_dw (
    id                  NUMBER(10)      NOT NULL,
    first_name          VARCHAR(40)     NOT NULL,
    last_name           VARCHAR(40)     NOT NULL,
    email               VARCHAR(100)    NOT NULL,
    phone               VARCHAR(12), 
    address             VARCHAR(100),
    city                VARCHAR(40),
    state               CHAR(2),
    zip                 CHAR(5),
    data_source         VARCHAR(5)      NOT NULL,
    CONSTRAINT pk_members_dw PRIMARY KEY (id, data_source)
);

--problem 3
CREATE VIEW members_view AS
SELECT
    m.member_id AS id,
    m.first_name,
    m.last_name,
    m.email_address AS email,
    CASE
        WHEN mp.phone_number IS NOT NULL THEN SUBSTR(mp.phone_number, 1, 3) || '-' || SUBSTR(mp.phone_number, 4, 3) || '-' || SUBSTR(mp.phone_number, 7, 4)
        ELSE NULL
    END AS phone,
    m.address,
    'Bend' AS city,
    'OR' AS state,
    m.zip_code AS zip,
    'ORIG' AS data_source
FROM
    members m
LEFT JOIN
    member_phone mp ON m.member_id = mp.member_id;

CREATE VIEW members_acquired_view AS
SELECT
    acquired_member_id AS id,
    ma_first_name AS first_name,
    ma_last_name AS last_name,
    ma_email AS email,
    CASE
        WHEN LENGTH(ma_phone) = 10 THEN SUBSTR(ma_phone, 1, 3) || '-' || SUBSTR(ma_phone, 4, 3) || '-' || SUBSTR(ma_phone, 7, 4)
        ELSE NULL
    END AS phone,
    SUBSTR(ma_address, 1, LENGTH(ma_address) - 6) AS address, 
    'Bend' AS city,
    'OR' AS state,
    ma_zip_code AS zip,
    'AQUI' AS data_source
FROM
    members_acquired;

--problem 4
CREATE OR REPLACE PROCEDURE InsertNewMembersIntoDW AS
BEGIN
    
    INSERT INTO members_dw (id, first_name, last_name, email, phone, address, city, state, zip, data_source)
    SELECT *
    FROM members_view
    WHERE (id, data_source) NOT IN (SELECT id, data_source FROM members_dw);

    
    INSERT INTO members_dw (id, first_name, last_name, email, phone, address, city, state, zip, data_source)
    SELECT *
    FROM members_acquired_view
    WHERE (id, data_source) NOT IN (SELECT id, data_source FROM members_dw);
    
    COMMIT;
END;
/

EXEC InsertNewMembersIntoDW;

--problem 5
CREATE OR REPLACE PROCEDURE UpdateMembersDW AS
BEGIN
    MERGE INTO members_dw t
    USING (
        SELECT *
        FROM members_view
    ) v
    ON (t.id = v.id AND t.data_source = v.data_source)
    WHEN MATCHED THEN
        UPDATE SET
            t.first_name = v.first_name,
            t.last_name = v.last_name,
            t.email = v.email,
            t.phone = v.phone,
            t.address = v.address,
            t.city = v.city,
            t.state = v.state,
            t.zip = v.zip;
    
    MERGE INTO members_dw t
    USING (
        SELECT *
        FROM members_acquired_view
    ) v
    ON (t.id = v.id AND t.data_source = v.data_source)
    WHEN MATCHED THEN
        UPDATE SET
            t.first_name = v.first_name,
            t.last_name = v.last_name,
            t.email = v.email,
            t.phone = v.phone,
            t.address = v.address,
            t.city = v.city,
            t.state = v.state,
            t.zip = v.zip;
    
    COMMIT;
END;
/

--problem 6
CREATE OR REPLACE PROCEDURE members_etl_proc AS
BEGIN
    
    INSERT INTO members_dw (id, first_name, last_name, email, phone, address, city, state, zip, data_source)
    SELECT *
    FROM members_view
    WHERE (id, data_source) NOT IN (SELECT id, data_source FROM members_dw);

    INSERT INTO members_dw (id, first_name, last_name, email, phone, address, city, state, zip, data_source)
    SELECT *
    FROM members_acquired_view
    WHERE (id, data_source) NOT IN (SELECT id, data_source FROM members_dw);

    MERGE INTO members_dw t
    USING (
        SELECT *
        FROM members_view
    ) v
    ON (t.id = v.id AND t.data_source = v.data_source)
    WHEN MATCHED THEN
        UPDATE SET
            t.first_name = v.first_name,
            t.last_name = v.last_name,
            t.email = v.email,
            t.phone = v.phone,
            t.address = v.address,
            t.city = v.city,
            t.state = v.state,
            t.zip = v.zip;

    MERGE INTO members_dw t
    USING (
        SELECT *
        FROM members_acquired_view
    ) v
    ON (t.id = v.id AND t.data_source = v.data_source)
    WHEN MATCHED THEN
        UPDATE SET
            t.first_name = v.first_name,
            t.last_name = v.last_name,
            t.email = v.email,
            t.phone = v.phone,
            t.address = v.address,
            t.city = v.city,
            t.state = v.state,
            t.zip = v.zip;

    COMMIT;
END;
/








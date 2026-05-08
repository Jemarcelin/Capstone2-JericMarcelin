SELECT * FROM adventureworks.dim_date;

USE adventureworks;

DROP TABLE IF EXISTS dim_date;

CREATE TABLE dim_date (
    DateKey             INT NOT NULL,
    Date                DATE NOT NULL,
    Day                 TINYINT NOT NULL,
    DaySuffix           CHAR(2) NOT NULL,
    Weekday             TINYINT NOT NULL,
    WeekDayName         VARCHAR(10) NOT NULL,
    WeekDayName_Short   CHAR(3) NOT NULL,
    DOWInMonth          TINYINT NOT NULL,
    DayOfYear           SMALLINT NOT NULL,
    WeekOfMonth         TINYINT NOT NULL,
    WeekOfYear          TINYINT NOT NULL,
    Month               TINYINT NOT NULL,
    MonthName           VARCHAR(10) NOT NULL,
    MonthName_Short     CHAR(3) NOT NULL,
    Quarter             TINYINT NOT NULL,
    QuarterName         VARCHAR(6) NOT NULL,
    Year                INT NOT NULL,
    MMYYYY              CHAR(6) NOT NULL,
    MonthYear           CHAR(7) NOT NULL,
    IsWeekend           BIT NOT NULL,
    IsHoliday           BIT NOT NULL,
    HolidayName         VARCHAR(20) NULL,
    SpecialDays         VARCHAR(20) NULL,
    FirstDateofYear     DATE NULL,
    LastDateofYear      DATE NULL,
    FirstDateofMonth    DATE NULL,
    LastDateofMonth     DATE NULL,
    FirstDateofWeek     DATE NULL,
    LastDateofWeek      DATE NULL,
    PRIMARY KEY (DateKey)
);

-- =============================================================================
-- Populate dim_date using a loop
-- =============================================================================
DROP PROCEDURE IF EXISTS populate_dim_date;

DELIMITER $$

CREATE PROCEDURE populate_dim_date()
BEGIN
    DECLARE current_date_val DATE DEFAULT '2000-01-01';
    DECLARE end_date DATE DEFAULT '2004-12-31';

    WHILE current_date_val <= end_date DO
        INSERT INTO dim_date (
            DateKey, Date, Day, DaySuffix, Weekday, WeekDayName,
            WeekDayName_Short, DOWInMonth, DayOfYear, WeekOfMonth,
            WeekOfYear, Month, MonthName, MonthName_Short, Quarter,
            QuarterName, Year, MMYYYY, MonthYear, IsWeekend, IsHoliday,
            FirstDateofYear, LastDateofYear, FirstDateofMonth,
            LastDateofMonth, FirstDateofWeek, LastDateofWeek
        )
        VALUES (
            -- DateKey: YYYYMMDD integer
            YEAR(current_date_val) * 10000 + MONTH(current_date_val) * 100 + DAY(current_date_val),

            -- Date
            current_date_val,

            -- Day
            DAY(current_date_val),

            -- DaySuffix
            CASE
                WHEN DAY(current_date_val) IN (1,21,31) THEN 'st'
                WHEN DAY(current_date_val) IN (2,22)    THEN 'nd'
                WHEN DAY(current_date_val) IN (3,23)    THEN 'rd'
                ELSE 'th'
            END,

            -- Weekday (1=Sunday, 7=Saturday in MySQL)
            DAYOFWEEK(current_date_val),

            -- WeekDayName
            DAYNAME(current_date_val),

            -- WeekDayName_Short
            UPPER(LEFT(DAYNAME(current_date_val), 3)),

            -- DOWInMonth
            DAY(current_date_val),

            -- DayOfYear
            DAYOFYEAR(current_date_val),

            -- WeekOfMonth
            FLOOR((DAY(current_date_val) - 1) / 7) + 1,

            -- WeekOfYear
            WEEK(current_date_val, 1),

            -- Month
            MONTH(current_date_val),

            -- MonthName
            MONTHNAME(current_date_val),

            -- MonthName_Short
            UPPER(LEFT(MONTHNAME(current_date_val), 3)),

            -- Quarter
            QUARTER(current_date_val),

            -- QuarterName
            CASE QUARTER(current_date_val)
                WHEN 1 THEN 'First'
                WHEN 2 THEN 'Second'
                WHEN 3 THEN 'Third'
                WHEN 4 THEN 'Fourth'
            END,

            -- Year
            YEAR(current_date_val),

            -- MMYYYY
            CONCAT(LPAD(MONTH(current_date_val), 2, '0'), YEAR(current_date_val)),

            -- MonthYear
            CONCAT(YEAR(current_date_val), UPPER(LEFT(MONTHNAME(current_date_val), 3))),

            -- IsWeekend
            CASE WHEN DAYOFWEEK(current_date_val) IN (1,7) THEN 1 ELSE 0 END,

            -- IsHoliday (default 0, updated below)
            0,

            -- FirstDateofYear
            DATE(CONCAT(YEAR(current_date_val), '-01-01')),

            -- LastDateofYear
            DATE(CONCAT(YEAR(current_date_val), '-12-31')),

            -- FirstDateofMonth
            DATE(CONCAT(YEAR(current_date_val), '-', LPAD(MONTH(current_date_val), 2, '0'), '-01')),

            -- LastDateofMonth
            LAST_DAY(current_date_val),

            -- FirstDateofWeek (Monday-based)
            DATE_SUB(current_date_val, INTERVAL (DAYOFWEEK(current_date_val) - 1) DAY),

            -- LastDateofWeek
            DATE_ADD(current_date_val, INTERVAL (7 - DAYOFWEEK(current_date_val)) DAY)
        );

        SET current_date_val = DATE_ADD(current_date_val, INTERVAL 1 DAY);
    END WHILE;
END$$

DELIMITER ;

-- Run the procedure
CALL populate_dim_date();

-- =============================================================================
-- Update Holiday and Special Days
-- =============================================================================
UPDATE dim_date SET IsHoliday = 1, HolidayName = 'Christmas'
WHERE Month = 12 AND Day = 25;

UPDATE dim_date SET IsHoliday = 1, HolidayName = 'New Years Day'
WHERE Month = 1 AND Day = 1;

UPDATE dim_date SET SpecialDays = 'Valentines Day'
WHERE Month = 2 AND Day = 14;

-- =============================================================================
-- Verify
-- =============================================================================
SELECT COUNT(*) AS total_rows FROM dim_date;
SELECT * FROM dim_date LIMIT 5;

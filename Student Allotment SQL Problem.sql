CREATE DATABASE CollegeAllotment;
USE CollegeAllotment;

CREATE TABLE StudentDetails (
    StudentId INT PRIMARY KEY,
    StudentName VARCHAR(100),
    GPA DECIMAL(3, 2),
    Branch VARCHAR(50),
    Section VARCHAR(10)
);

CREATE TABLE SubjectDetails (
    SubjectId VARCHAR(10) PRIMARY KEY,
    SubjectName VARCHAR(100),
    MaxSeats INT,
    RemainingSeats INT
);

CREATE TABLE StudentPreference (
    StudentId INT,
    SubjectId VARCHAR(10),
    Preference INT,
    FOREIGN KEY (StudentId) REFERENCES StudentDetails(StudentId),
    FOREIGN KEY (SubjectId) REFERENCES SubjectDetails(SubjectId),
    UNIQUE(StudentId, SubjectId)
);

CREATE TABLE Allotments (
    SubjectId VARCHAR(10),
    StudentId INT,
    FOREIGN KEY (SubjectId) REFERENCES SubjectDetails(SubjectId),
    FOREIGN KEY (StudentId) REFERENCES StudentDetails(StudentId)
);

CREATE TABLE UnallottedStudents (
    StudentId INT,
    FOREIGN KEY (StudentId) REFERENCES StudentDetails(StudentId)
);

INSERT INTO StudentDetails VALUES
(159103036, 'Mohit Agarwal', 8.9, 'CCE', 'A'),
(159103037, 'Rohit Agarwal', 5.2, 'CCE', 'A'),
(159103038, 'Shohit Garg', 7.1, 'CCE', 'B'),
(159103039, 'Mrinal Malhotra', 7.9, 'CCE', 'A'),
(159103040, 'Mehreet Singh', 5.6, 'CCE', 'A'),
(159103041, 'Arjun Tehlan', 9.2, 'CCE', 'B');

INSERT INTO SubjectDetails (SubjectId, SubjectName, MaxSeats, RemainingSeats) VALUES
('PO1491', 'Basics of Political Science', 60, 2),
('PO1492', 'Basics of Accounting', 120, 119),
('PO1493', 'Basics of Financial Markets', 90, 90),
('PO1494', 'Eco philosophy', 60, 50),
('PO1495', 'Automotive Trends', 60, 60);

INSERT INTO StudentPreference (StudentId, SubjectId, Preference) VALUES
(159103036, 'PO1491', 1),
(159103036, 'PO1492', 2),
(159103036, 'PO1493', 3),
(159103036, 'PO1494', 4),
(159103036, 'PO1495', 5);

INSERT INTO StudentPreference (StudentId, SubjectId, Preference) VALUES
(159103037, 'PO1492', 1),
(159103037, 'PO1493', 2),
(159103037, 'PO1491', 3),
(159103037, 'PO1495', 4),
(159103037, 'PO1494', 5),

(159103038, 'PO1493', 1),
(159103038, 'PO1492', 2),
(159103038, 'PO1491', 3),
(159103038, 'PO1495', 4),
(159103038, 'PO1494', 5),

(159103039, 'PO1492', 1),
(159103039, 'PO1494', 2),
(159103039, 'PO1493', 3),
(159103039, 'PO1495', 4),
(159103039, 'PO1491', 5),

(159103040, 'PO1495', 1),
(159103040, 'PO1492', 2),
(159103040, 'PO1493', 3),
(159103040, 'PO1491', 4),
(159103040, 'PO1494', 5),

(159103041, 'PO1491', 1),
(159103041, 'PO1492', 2),
(159103041, 'PO1493', 3),
(159103041, 'PO1494', 4),
(159103041, 'PO1495', 5);



DELIMITER $$

CREATE PROCEDURE AllocateSubjects()
BEGIN
    -- Declare variables at the start
    DECLARE done INT DEFAULT FALSE;
    DECLARE stuId INT;
    DECLARE pref INT;
    DECLARE subject_found BOOLEAN;
    DECLARE subId VARCHAR(10);
    DECLARE remaining INT;

    -- Declare cursor
    DECLARE cur CURSOR FOR 
        SELECT StudentId FROM StudentDetails ORDER BY GPA DESC;

    -- Declare handler for end of cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    student_loop: LOOP
        FETCH cur INTO stuId;
        IF done THEN
            LEAVE student_loop;
        END IF;

        SET pref = 1;
        SET subject_found = FALSE;

        preference_loop: WHILE pref <= 5 DO
            -- Get subjectId for the current preference
            SELECT SubjectId INTO subId
            FROM StudentPreference
            WHERE StudentId = stuId AND Preference = pref;

            -- If subjectId is null (no preference found), move to next preference
            IF subId IS NULL THEN
                SET pref = pref + 1;
                ITERATE preference_loop;
            END IF;

            -- Check remaining seats for the subject
            SELECT RemainingSeats INTO remaining
            FROM SubjectDetails
            WHERE SubjectId = subId;

            IF remaining > 0 THEN
                -- Allocate subject to student
                INSERT INTO Allotments (SubjectId, StudentId)
                VALUES (subId, stuId);

                -- Decrease the remaining seats
                UPDATE SubjectDetails
                SET RemainingSeats = RemainingSeats - 1
                WHERE SubjectId = subId;

                SET subject_found = TRUE;
                LEAVE preference_loop;  -- Exit preference checking for this student
            ELSE
                -- Try next preference
                SET pref = pref + 1;
            END IF;
        END WHILE preference_loop;

        -- If subject not allotted, mark as unallotted
        IF NOT subject_found THEN
            INSERT INTO UnallottedStudents (StudentId)
            VALUES (stuId);
        END IF;

    END LOOP student_loop;

    CLOSE cur;
END $$

DELIMITER ;

CALL AllocateSubjects();


SELECT * FROM Allotments;

SELECT * FROM UnallottedStudents;

SELECT * FROM SubjectDetails;



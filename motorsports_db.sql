CREATE DATABASE motorsports_db;
USE motorsports_db;





CREATE TABLE drivers (
    driver_id INT AUTO_INCREMENT PRIMARY KEY,
    car_number INT UNIQUE NOT NULL
);

CREATE TABLE races (
    race_id INT AUTO_INCREMENT PRIMARY KEY,
    race_date DATETIME DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE race_results (
    result_id INT AUTO_INCREMENT PRIMARY KEY,
    driver_id INT,
    race_id INT,
    completed_laps INT NOT NULL,
    `rank` INT NOT NULL,  -- Backticks used to avoid conflict with reserved keyword
    elapsed_time FLOAT NOT NULL,
    rank_diff FLOAT NOT NULL,
    time_diff FLOAT NOT NULL,
    FOREIGN KEY (driver_id) REFERENCES drivers(driver_id) ON DELETE CASCADE,
    FOREIGN KEY (race_id) REFERENCES races(race_id) ON DELETE CASCADE
);

INSERT INTO drivers (car_number) VALUES
(1), (39), (150), (233), (313), (395), (476), (560), (645);

INSERT INTO races (race_date) VALUES
('2025-03-07 12:00:00'),
('2025-03-14 12:00:00');

INSERT INTO race_results (driver_id, race_id, completed_laps, `rank`, elapsed_time, rank_diff, time_diff) VALUES
(1, 1, 1, 4, 42.7829, 0, 42.3679),
(2, 1, 1, 2, 83.8813, 0, 41.0984),
(3, 1, 1, 3, 124.9756, 0, 41.0943),
(4, 1, 1, 1, 166.0936, 0, 41.118);


DELIMITER //

CREATE PROCEDURE update_rank()
BEGIN
    UPDATE race_results r
    JOIN (
        SELECT result_id, RANK() OVER (ORDER BY elapsed_time ASC) AS new_rank
        FROM race_results
    ) ranked
    ON r.result_id = ranked.result_id
    SET r.rank = ranked.new_rank;
END //

DELIMITER ;



CALL update_rank();

DELIMITER //

CREATE TRIGGER after_insert_race_result
AFTER INSERT ON race_results
FOR EACH ROW
BEGIN
    CALL update_rank();
END //

DELIMITER ;

SELECT * FROM drivers;
SELECT * FROM races;
SELECT * FROM race_results;


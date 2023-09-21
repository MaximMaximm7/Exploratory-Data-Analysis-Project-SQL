-- Keep a log of any SQL queries you execute as you solve the mystery.

-- find a crime scene report about 'duck'
SELECT * FROM crime_scene_reports;
SELECT * FROM crime_scene_reports WHERE street = 'Humphrey Street';
SELECT * FROM crime_scene_reports WHERE street = 'Humphrey Street' AND day = 28;
SELECT * FROM crime_scene_reports WHERE street = 'Humphrey Street' AND day = 28 AND description  LIKE '%duck%';
| 295 | 2021 | 7     | 28  | Humphrey Street | Theft of the CS50 duck took place at 10:15am
at the Humphrey Street bakery. Interviews were conducted today with three witnesses who were present
at the time – each of their interview transcripts mentions the bakery. |

-- find all persons who left Bakery from 10am to 11 as theft took place at 10:15am
SELECT * FROM bakery_security_logs;
SELECT * FROM bakery_security_logs WHERE day = 28;
SELECT * FROM bakery_security_logs WHERE day = 28 AND activity = 'exit' AND hour >= 10 AND hour <= 11;
| 260 | 2021 | 7     | 28  | 10   | 16     | exit     | 5P2BI95       |
| 261 | 2021 | 7     | 28  | 10   | 18     | exit     | 94KL13X       |
| 262 | 2021 | 7     | 28  | 10   | 18     | exit     | 6P58WS2       |
| 263 | 2021 | 7     | 28  | 10   | 19     | exit     | 4328GD8       |
| 264 | 2021 | 7     | 28  | 10   | 20     | exit     | G412CB7       |
| 265 | 2021 | 7     | 28  | 10   | 21     | exit     | L93JTIZ       |
| 266 | 2021 | 7     | 28  | 10   | 23     | exit     | 322W7JE       |
| 267 | 2021 | 7     | 28  | 10   | 23     | exit     | 0NTHK55       |
| 268 | 2021 | 7     | 28  | 10   | 35     | exit     | 1106N58       |

-- find all flights which flew from Fiftyville on  July 28, 2021 from 10am
SELECT * FROM flights WHERE day = 28 AND hour >= 10 ORDER BY hour ASC;
| id | origin_airport_id | destination_airport_id | year | month | day | hour | minute |
+----+-------------------+------------------------+------+-------+-----+------+--------+
| 22 | 1                 | 8                      | 2021 | 7     | 28  | 12   | 51     |
| 6  | 8                 | 5                      | 2021 | 7     | 28  | 13   | 49     |
| 40 | 7                 | 8                      | 2021 | 7     | 28  | 13   | 47     |
| 41 | 3                 | 8                      | 2021 | 7     | 28  | 14   | 14     |
| 20 | 6                 | 8                      | 2021 | 7     | 28  | 15   | 22     |
| 35 | 8                 | 4                      | 2021 | 7     | 28  | 16   | 16     |
| 1  | 8                 | 7                      | 2021 | 7     | 28  | 17   | 50     |
| 33 | 6                 | 8                      | 2021 | 7     | 28  | 17   | 58     |
| 34 | 8                 | 5                      | 2021 | 7     | 28  | 17   | 20     |
| 51 | 4                 | 8                      | 2021 | 7     | 28  | 18   | 3      |
| 17 | 8                 | 4                      | 2021 | 7     | 28  | 20   | 16     |
| 19 | 2                 | 8                      | 2021 | 7     | 28  | 21   | 15     |

-- The THIEF is: was in Bakery on July 28, 2021 + left from 10:00 to 11:00 + flew away on flights.day = 28
SELECT people.name FROM bakery_security_logs, people, passengers, flights WHERE bakery_security_logs.license_plate = people.license_plate AND bakery_security_logs.day = 28 AND bakery_security_logs.activity = 'exit' AND bakery_security_logs.hour >= 10 AND bakery_security_logs.hour <= 11
AND people.passport_number = passengers.passport_number AND passengers.flight_id = flights.id AND flights.day = 28 AND flights.hour >= 10;
+---------+
|  name   |
+---------+
| Vanessa |

-- all info about THIEF:
SELECT * FROM people, bakery_security_logs WHERE bakery_security_logs.license_plate = people.license_plate AND bakery_security_logs.day = 28 AND bakery_security_logs.activity = 'exit' AND bakery_security_logs.hour >= 10 AND bakery_security_logs.hour <= 11
AND people.name = 'Vanessa';
+--------+---------+----------------+-----------------+---------------+-----+------+-------+-----+------+--------+----------+---------------+
|   id   |  name   |  phone_number  | passport_number | license_plate | id  | year | month | day | hour | minute | activity | license_plate |
+--------+---------+----------------+-----------------+---------------+-----+------+-------+-----+------+--------+----------+---------------+
| 221103 | Vanessa | (725) 555-4692 | 2963008352      | 5P2BI95       | 260 | 2021 | 7     | 28  | 10   | 16     | exit     | 5P2BI95       |
+--------+---------+----------------+-----------------+---------------+-----+------+-------+-----+------+--------+----------+---------------+

-- The city the thief ESCAPED TO: destination_airport_id INTEGER
SELECT flights.origin_airport_id, flights.destination_airport_id FROM airports, flights, passengers
WHERE passengers.passport_number = 2963008352 AND passengers.flight_id = flights.id AND flights.day = 28 AND flights.hour >= 10 AND airports.id = flights.origin_airport_id;
+-------------------+------------------------+
| origin_airport_id | destination_airport_id |
+-------------------+------------------------+
| 6                 | 8                      |
+-------------------+------------------------+

-- find all info about this flight
SELECT * FROM airports, flights, passengers
WHERE passengers.passport_number = 2963008352 AND passengers.flight_id = flights.id AND flights.day = 28 AND flights.hour >= 10 AND airports.id = flights.origin_airport_id;
+----+--------------+-----------------------------+--------+----+-------------------+------------------------+------+-------+-----+------+--------+-----------+-----------------+------+
| id | abbreviation |          full_name          |  city  | id | origin_airport_id | destination_airport_id | year | month | day | hour | minute | flight_id | passport_number | seat |
+----+--------------+-----------------------------+--------+----+-------------------+------------------------+------+-------+-----+------+--------+-----------+-----------------+------+
| 6  | BOS          | Logan International Airport | Boston | 20 | 6                 | 8                      | 2021 | 7     | 28  | 15   | 22     | 20        | 2963008352      | 6B   |
+----+--------------+-----------------------------+--------+----+-------------------+------------------------+------+-------+-----+------+--------+-----------+-----------------+------+

-- find the origin_airport_city:
SELECT airports.city AS origin_airport_city FROM airports WHERE airports.id = 6;
+---------------------+
| origin_airport_city |
+---------------------+
| Boston              |
+---------------------+

-- find the destination_airport_city:
SELECT airports.city AS destination_airport_city FROM airports WHERE airports.id = 8;
+--------------------------+
| destination_airport_city |
+--------------------------+
| Fiftyville               |
+--------------------------+

-- suspect 'Vanessa' is not approved as origin_airport_city is not Fiftyville !!!

-- The THIEF is: was in Bakery on July 28, 2021 + left from 10:00 to 11:00 + flew away on ???  / flights.day > 28...

-- flights.day = 29
SELECT people.name FROM bakery_security_logs, people, passengers, flights WHERE bakery_security_logs.license_plate = people.license_plate AND bakery_security_logs.day = 28 AND bakery_security_logs.activity = 'exit' AND bakery_security_logs.hour >= 10 AND bakery_security_logs.hour <= 11
AND people.passport_number = passengers.passport_number AND passengers.flight_id = flights.id AND flights.day = 29;
+--------+
|  name  |
+--------+
| Diana  |
| Sofia  |
| Bruce  |
| Kelsey |
| Taylor |
| Luca   |
+--------+

-- origin_airport_city have to be 8 (Fiftyville)
SELECT people.name FROM bakery_security_logs, people, passengers, flights WHERE bakery_security_logs.license_plate = people.license_plate AND bakery_security_logs.day = 28 AND bakery_security_logs.activity = 'exit' AND bakery_security_logs.hour >= 10 AND bakery_security_logs.hour <= 11
AND people.passport_number = passengers.passport_number AND passengers.flight_id = flights.id AND flights.day = 29 AND flights.origin_airport_id = 8;
+--------+
|  name  |
+--------+
| Diana  |
| Sofia  |
| Bruce  |
| Kelsey |
| Taylor |
| Luca   |
+--------+

-- repeating previous steps as with Vanessa
SELECT * FROM people, bakery_security_logs WHERE bakery_security_logs.license_plate = people.license_plate AND bakery_security_logs.day = 28 AND bakery_security_logs.activity = 'exit' AND bakery_security_logs.hour >= 10 AND bakery_security_logs.hour <= 11;
+--------+---------+----------------+-----------------+---------------+-----+------+-------+-----+------+--------+----------+---------------+
|   id   |  name   |  phone_number  | passport_number | license_plate | id  | year | month | day | hour | minute | activity | license_plate |
+--------+---------+----------------+-----------------+---------------+-----+------+-------+-----+------+--------+----------+---------------+
| 221103 | Vanessa | (725) 555-4692 | 2963008352      | 5P2BI95       | 260 | 2021 | 7     | 28  | 10   | 16     | exit     | 5P2BI95       |
| 686048 | Bruce   | (367) 555-5533 | 5773159633      | 94KL13X       | 261 | 2021 | 7     | 28  | 10   | 18     | exit     | 94KL13X       |
| 243696 | Barry   | (301) 555-4174 | 7526138472      | 6P58WS2       | 262 | 2021 | 7     | 28  | 10   | 18     | exit     | 6P58WS2       |
| 467400 | Luca    | (389) 555-5198 | 8496433585      | 4328GD8       | 263 | 2021 | 7     | 28  | 10   | 19     | exit     | 4328GD8       |
| 398010 | Sofia   | (130) 555-0289 | 1695452385      | G412CB7       | 264 | 2021 | 7     | 28  | 10   | 20     | exit     | G412CB7       |
| 396669 | Iman    | (829) 555-5269 | 7049073643      | L93JTIZ       | 265 | 2021 | 7     | 28  | 10   | 21     | exit     | L93JTIZ       |
| 514354 | Diana   | (770) 555-1861 | 3592750733      | 322W7JE       | 266 | 2021 | 7     | 28  | 10   | 23     | exit     | 322W7JE       |
| 560886 | Kelsey  | (499) 555-9472 | 8294398571      | 0NTHK55       | 267 | 2021 | 7     | 28  | 10   | 23     | exit     | 0NTHK55       |
| 449774 | Taylor  | (286) 555-6063 | 1988161715      | 1106N58       | 268 | 2021 | 7     | 28  | 10   | 35     | exit     | 1106N58       |
+--------+---------+----------------+-----------------+---------------+-----+------+-------+-----+------+--------+----------+---------------+

-- Merge of two tables above and deleting Vanessa (6 suspects)
+--------+---------+----------------+-----------------+---------------+-----+------+-------+-----+------+--------+----------+---------------+
|   id   |  name   |  phone_number  | passport_number | license_plate | id  | year | month | day | hour | minute | activity | license_plate |
+--------+---------+----------------+-----------------+---------------+-----+------+-------+-----+------+--------+----------+---------------+
| 686048 | Bruce   | (367) 555-5533 | 5773159633      | 94KL13X       | 261 | 2021 | 7     | 28  | 10   | 18     | exit     | 94KL13X       |
| 467400 | Luca    | (389) 555-5198 | 8496433585      | 4328GD8       | 263 | 2021 | 7     | 28  | 10   | 19     | exit     | 4328GD8       |
| 398010 | Sofia   | (130) 555-0289 | 1695452385      | G412CB7       | 264 | 2021 | 7     | 28  | 10   | 20     | exit     | G412CB7       |
| 514354 | Diana   | (770) 555-1861 | 3592750733      | 322W7JE       | 266 | 2021 | 7     | 28  | 10   | 23     | exit     | 322W7JE       |
| 560886 | Kelsey  | (499) 555-9472 | 8294398571      | 0NTHK55       | 267 | 2021 | 7     | 28  | 10   | 23     | exit     | 0NTHK55       |
| 449774 | Taylor  | (286) 555-6063 | 1988161715      | 1106N58       | 268 | 2021 | 7     | 28  | 10   | 35     | exit     | 1106N58       |
+--------+---------+----------------+-----------------+---------------+-----+------+-------+-----+------+--------+----------+---------------+
-- getting six new suspects / flights.origin_airport_id = 8 (Fiftyville) / flights.day = 29

-- to weed out list of suspects we need more info from interviews
SELECT * FROM interviews WHERE interviews.day = 28 AND interviews.year = 2021 AND interviews.month = 07 AND transcript LIKE '%bakery%';
| id  |  name   | year | month | day |                                                                                                                                                     transcript                                                                                                                                                      |
+-----+---------+------+-------+-----+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| 161 | Ruth    | 2021 | 7     | 28  | Sometime within ten minutes of the theft, I saw the thief get into a car in the bakery parking lot and drive away. If you have security footage from the bakery parking lot, you might want to look for cars that left the parking lot in that time frame.                                                          |
| 162 | Eugene  | 2021 | 7     | 28  | I don't know the thief's name, but it was someone I recognized. Earlier this morning, before I arrived at Emma's bakery, I was walking by the ATM on Leggett Street and saw the thief there withdrawing some money.                                                                                                 |
| 163 | Raymond | 2021 | 7     | 28  | As the thief was leaving the bakery, they called someone who talked to them for less than a minute. In the call, I heard the thief say that they were planning to take the earliest flight out of Fiftyville tomorrow. The thief then asked the person on the other end of the phone to purchase the flight ticket. |
+-----+---------+------+-------+-----+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

-- after reviewing interviews we can clear out some suspects:

- Taylor -  because theft took place at 10:15am + Sometime within ten minutes of the theft get into a car in the bakery parking lot and drive away <= 10:25
but he left 10   | 35

-- updated suspects list 1 (five suspects):
+--------+---------+----------------+-----------------+---------------+-----+------+-------+-----+------+--------+----------+---------------+
|   id   |  name   |  phone_number  | passport_number | license_plate | id  | year | month | day | hour | minute | activity | license_plate |
+--------+---------+----------------+-----------------+---------------+-----+------+-------+-----+------+--------+----------+---------------+
| 686048 | Bruce   | (367) 555-5533 | 5773159633      | 94KL13X       | 261 | 2021 | 7     | 28  | 10   | 18     | exit     | 94KL13X       |
| 467400 | Luca    | (389) 555-5198 | 8496433585      | 4328GD8       | 263 | 2021 | 7     | 28  | 10   | 19     | exit     | 4328GD8       |
| 398010 | Sofia   | (130) 555-0289 | 1695452385      | G412CB7       | 264 | 2021 | 7     | 28  | 10   | 20     | exit     | G412CB7       |
| 514354 | Diana   | (770) 555-1861 | 3592750733      | 322W7JE       | 266 | 2021 | 7     | 28  | 10   | 23     | exit     | 322W7JE       |
| 560886 | Kelsey  | (499) 555-9472 | 8294398571      | 0NTHK55       | 267 | 2021 | 7     | 28  | 10   | 23     | exit     | 0NTHK55       |

-- to check - ATM (Earlier this morning) on Leggett Street and compare with the list of five suspects:
SELECT people.name FROM people, bank_accounts, atm_transactions WHERE people.id = bank_accounts.person_id
AND bank_accounts.account_number = atm_transactions.account_number
AND atm_transactions.atm_location = 'Leggett Street'
AND atm_transactions.day = 28 AND atm_transactions.year = 2021 AND atm_transactions.month = 07;
+---------+
|  name   |
+---------+
| Bruce   |
| Kaelyn  |
| Diana   |
| Brooke  |
| Kenny   |
| Iman    |
| Luca    |
| Taylor  |
| Benista |
+---------+

-- updated suspects list 2 (3 suspects):
+--------+---------+----------------+-----------------+---------------+-----+------+-------+-----+------+--------+----------+---------------+
|   id   |  name   |  phone_number  | passport_number | license_plate | id  | year | month | day | hour | minute | activity | license_plate |
+--------+---------+----------------+-----------------+---------------+-----+------+-------+-----+------+--------+----------+---------------+
| 686048 | Bruce   | (367) 555-5533 | 5773159633      | 94KL13X       | 261 | 2021 | 7     | 28  | 10   | 18     | exit     | 94KL13X       |
| 467400 | Luca    | (389) 555-5198 | 8496433585      | 4328GD8       | 263 | 2021 | 7     | 28  | 10   | 19     | exit     | 4328GD8       |
| 514354 | Diana   | (770) 555-1861 | 3592750733      | 322W7JE       | 266 | 2021 | 7     | 28  | 10   | 23     | exit     | 322W7JE       |

-- called someone who talked to them for less than a minute (in the period of 10:15am - 10   | 23  )
SELECT * FROM phone_calls, people WHERE phone_calls.id = people.id
AND phone_calls.day = 28 AND phone_calls.year = 2021 AND phone_calls.month = 07 AND people.name = 'Bruce';
-- these SQL query doesn't work

-- all
SELECT * FROM phone_calls WHERE phone_calls.day = 28 AND phone_calls.year = 2021 AND phone_calls.month = 07 ORDER BY duration ASC;
+-----+----------------+----------------+------+-------+-----+----------+
| id  |     caller     |    receiver    | year | month | day | duration |
+-----+----------------+----------------+------+-------+-----+----------+
| 224 | (499) 555-9472 | (892) 555-8872 | 2021 | 7     | 28  | 36       |
| 261 | (031) 555-6622 | (910) 555-3251 | 2021 | 7     | 28  | 38       |
| 254 | (286) 555-6063 | (676) 555-6554 | 2021 | 7     | 28  | 43       |
| 233 | (367) 555-5533 | (375) 555-8161 | 2021 | 7     | 28  | 45       |
| 255 | (770) 555-1861 | (725) 555-3243 | 2021 | 7     | 28  | 49       |
| 251 | (499) 555-9472 | (717) 555-1342 | 2021 | 7     | 28  | 50       |
| 221 | (130) 555-0289 | (996) 555-8899 | 2021 | 7     | 28  | 51       |
| 281 | (338) 555-6650 | (704) 555-2131 | 2021 | 7     | 28  | 54       |
| 279 | (826) 555-1652 | (066) 555-9701 | 2021 | 7     | 28  | 55       |
| 234 | (609) 555-5876 | (389) 555-5198 | 2021 | 7     | 28  | 60       |
| 271 | (751) 555-6567 | (594) 555-6254 | 2021 | 7     | 28  | 61       |
| 260 | (669) 555-6918 | (971) 555-6468 | 2021 | 7     | 28  | 67       |
| 240 | (636) 555-4198 | (670) 555-8598 | 2021 | 7     | 28  | 69       |
| 285 | (367) 555-5533 | (704) 555-5790 | 2021 | 7     | 28  | 75       |
| 266 | (016) 555-9166 | (336) 555-0077 | 2021 | 7     | 28  | 88       |

-- Bruce
SELECT * FROM phone_calls WHERE phone_calls.caller = '(367) 555-5533'
AND phone_calls.day = 28 AND phone_calls.year = 2021 AND phone_calls.month = 07;
+-----+----------------+----------------+------+-------+-----+----------+
| id  |     caller     |    receiver    | year | month | day | duration |
+-----+----------------+----------------+------+-------+-----+----------+
| 233 | (367) 555-5533 | (375) 555-8161 | 2021 | 7     | 28  | 45       |
| 236 | (367) 555-5533 | (344) 555-9601 | 2021 | 7     | 28  | 120      |
| 245 | (367) 555-5533 | (022) 555-4052 | 2021 | 7     | 28  | 241      |
| 285 | (367) 555-5533 | (704) 555-5790 | 2021 | 7     | 28  | 75       |
+-----+----------------+----------------+------+-------+-----+----------+

-- Luca
SELECT * FROM phone_calls WHERE phone_calls.caller = '(389) 555-5198'
AND phone_calls.day = 28 AND phone_calls.year = 2021 AND phone_calls.month = 07;
N/A

-- Diana
SELECT * FROM phone_calls WHERE phone_calls.caller = '(770) 555-1861'
AND phone_calls.day = 28 AND phone_calls.year = 2021 AND phone_calls.month = 07;
+-----+----------------+----------------+------+-------+-----+----------+
| id  |     caller     |    receiver    | year | month | day | duration |
+-----+----------------+----------------+------+-------+-----+----------+
| 255 | (770) 555-1861 | (725) 555-3243 | 2021 | 7     | 28  | 49       |
+-----+----------------+----------------+------+-------+-----+----------+s

-- updated suspects list 3 (2 suspects):
+--------+---------+----------------+-----------------+---------------+-----+------+-------+-----+------+--------+----------+---------------+
|   id   |  name   |  phone_number  | passport_number | license_plate | id  | year | month | day | hour | minute | activity | license_plate |
+--------+---------+----------------+-----------------+---------------+-----+------+-------+-----+------+--------+----------+---------------+
| 686048 | Bruce   | (367) 555-5533 | 5773159633      | 94KL13X       | 261 | 2021 | 7     | 28  | 10   | 18     | exit     | 94KL13X       |
| 514354 | Diana   | (770) 555-1861 | 3592750733      | 322W7JE       | 266 | 2021 | 7     | 28  | 10   | 23     | exit     | 322W7JE       |


-- earliest flight out of Fiftyville tomorrow (approved data off of the flight is July 29th - earliest flight)
-- find all flights which flew from Fiftyville on  July 29, 2021
SELECT * FROM flights WHERE day = 29 ORDER BY hour ASC;
+----+-------------------+------------------------+------+-------+-----+------+--------+
| id | origin_airport_id | destination_airport_id | year | month | day | hour | minute |
+----+-------------------+------------------------+------+-------+-----+------+--------+
| 36 | 8                 | 4                      | 2021 | 7     | 29  | 8    | 20     |
| 43 | 8                 | 1                      | 2021 | 7     | 29  | 9    | 30     |
| 23 | 8                 | 11                     | 2021 | 7     | 29  | 12   | 15     |
| 53 | 8                 | 9                      | 2021 | 7     | 29  | 15   | 20     |
| 18 | 8                 | 6                      | 2021 | 7     | 29  | 16   | 0      |
+----+-------------------+------------------------+------+-------+-----+------+--------+
-- find the airport_citys:
SELECT airports.city AS destination_airport_city FROM airports WHERE airports.id = 4;
+--------------------------+
| destination_airport_city |
+--------------------------+
| New York City            |
+--------------------------+
SELECT airports.city AS destination_airport_city FROM airports WHERE airports.id = 1;
+--------------------------+
| destination_airport_city |
+--------------------------+
| Chicago                  |
+--------------------------+
-- The city the thief ESCAPED TO: destination_airport_id INTEGER
-- find all info about this flight
-- find the origin_airport_city:
-- find the destination_airport_city:


-- flight which flew from Fiftyville on  July 29, 2021 - earliest flight
-- origin_airport_city have to be 8 (Fiftyville)
SELECT people.name FROM bakery_security_logs, people, passengers, flights WHERE bakery_security_logs.license_plate = people.license_plate AND bakery_security_logs.day = 28 AND bakery_security_logs.activity = 'exit' AND bakery_security_logs.hour >= 10 AND bakery_security_logs.hour <= 11
AND people.passport_number = passengers.passport_number AND passengers.flight_id = flights.id AND flights.day = 29 AND flights.origin_airport_id = 8 AND flights.id = 36;
+--------+
|  name  |
+--------+
| Bruce  |
| Luca   |
| Sofia  |
| Kelsey |
| Taylor |
+--------+

-- after merging this 2 tables (updated suspects list 3 (2 suspects) + first flight (earliest flight) from Fiftyville on July 29th) we can see that the THIEF is: Bruce

-- The city the thief ESCAPED TO: New York City,as first flight (earliest flight) from Fiftyville on July 29th)

-- The ACCOMPLICE is: who call THIEF on July 28, 2021 (THIEF called someone who talked to THIEF for less than a minute - only one suspect)
SELECT * FROM people WHERE people.phone_number = '(375) 555-8161';
+--------+-------+----------------+-----------------+---------------+
|   id   | name  |  phone_number  | passport_number | license_plate |
+--------+-------+----------------+-----------------+---------------+
| 864400 | Robin | (375) 555-8161 | NULL            | 4V16VO0       |
+--------+-------+----------------+-----------------+---------------+
-- The ACCOMPLICE is: Robin



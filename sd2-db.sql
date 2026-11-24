-- TravelMate read-only development database.
-- Rows below use generated labels and contain no real traveller contact data.
-- Import into the database selected by MYSQL_DATABASE / DB_NAME.

SET NAMES utf8mb4;
SET time_zone = '+00:00';

CREATE TABLE IF NOT EXISTS test_table (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(512) NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS travel_agents (
  agent_id INT UNSIGNED NOT NULL,
  display_name VARCHAR(100) NOT NULL,
  speciality VARCHAR(120) NOT NULL,
  PRIMARY KEY (agent_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS travellers (
  traveller_id INT UNSIGNED NOT NULL,
  display_name VARCHAR(100) NOT NULL,
  party_size TINYINT UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (traveller_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS tour_plans (
  plan_id INT UNSIGNED NOT NULL,
  reference_code VARCHAR(20) NOT NULL,
  title VARCHAR(160) NOT NULL,
  destination VARCHAR(160) NOT NULL,
  origin VARCHAR(120) NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  status ENUM('Draft', 'Shared', 'Approved') NOT NULL DEFAULT 'Draft',
  estimated_total DECIMAL(10,2) NOT NULL DEFAULT 0,
  currency CHAR(3) NOT NULL DEFAULT 'GBP',
  traveller_id INT UNSIGNED NOT NULL,
  agent_id INT UNSIGNED NOT NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  PRIMARY KEY (plan_id),
  UNIQUE KEY uq_tour_plans_reference (reference_code),
  KEY idx_tour_plans_status (status),
  KEY idx_tour_plans_destination (destination),
  KEY idx_tour_plans_start_date (start_date),
  CONSTRAINT fk_tour_plans_traveller FOREIGN KEY (traveller_id)
    REFERENCES travellers (traveller_id),
  CONSTRAINT fk_tour_plans_agent FOREIGN KEY (agent_id)
    REFERENCES travel_agents (agent_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS tour_days (
  day_id INT UNSIGNED NOT NULL,
  plan_id INT UNSIGNED NOT NULL,
  day_number TINYINT UNSIGNED NOT NULL,
  travel_date DATE NOT NULL,
  city VARCHAR(100) NOT NULL,
  summary VARCHAR(255) NOT NULL,
  PRIMARY KEY (day_id),
  UNIQUE KEY uq_tour_days_plan_day (plan_id, day_number),
  CONSTRAINT fk_tour_days_plan FOREIGN KEY (plan_id)
    REFERENCES tour_plans (plan_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS activities (
  activity_id INT UNSIGNED NOT NULL,
  day_id INT UNSIGNED NOT NULL,
  start_time TIME NULL,
  title VARCHAR(160) NOT NULL,
  location VARCHAR(160) NOT NULL,
  notes VARCHAR(500) NOT NULL DEFAULT '',
  estimated_cost DECIMAL(10,2) NOT NULL DEFAULT 0,
  currency CHAR(3) NOT NULL DEFAULT 'GBP',
  PRIMARY KEY (activity_id),
  KEY idx_activities_day (day_id),
  CONSTRAINT fk_activities_day FOREIGN KEY (day_id)
    REFERENCES tour_days (day_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS flight_estimates (
  flight_id INT UNSIGNED NOT NULL,
  plan_id INT UNSIGNED NOT NULL,
  outbound_route VARCHAR(160) NOT NULL,
  return_route VARCHAR(160) NOT NULL,
  departure_date DATE NOT NULL,
  return_date DATE NOT NULL,
  estimated_amount DECIMAL(10,2) NOT NULL,
  currency CHAR(3) NOT NULL DEFAULT 'GBP',
  estimate_note VARCHAR(255) NOT NULL,
  PRIMARY KEY (flight_id),
  UNIQUE KEY uq_flight_estimates_plan (plan_id),
  CONSTRAINT fk_flight_estimates_plan FOREIGN KEY (plan_id)
    REFERENCES tour_plans (plan_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS trip_costs (
  cost_id INT UNSIGNED NOT NULL,
  plan_id INT UNSIGNED NOT NULL,
  category VARCHAR(100) NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  currency CHAR(3) NOT NULL DEFAULT 'GBP',
  inclusion_note VARCHAR(255) NOT NULL,
  PRIMARY KEY (cost_id),
  KEY idx_trip_costs_plan (plan_id),
  CONSTRAINT fk_trip_costs_plan FOREIGN KEY (plan_id)
    REFERENCES tour_plans (plan_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS travel_videos (
  video_id INT UNSIGNED NOT NULL,
  plan_id INT UNSIGNED NOT NULL,
  title VARCHAR(160) NOT NULL,
  video_url VARCHAR(500) NULL,
  review_status ENUM('Pending', 'Verified') NOT NULL DEFAULT 'Pending',
  PRIMARY KEY (video_id),
  KEY idx_travel_videos_plan (plan_id),
  CONSTRAINT fk_travel_videos_plan FOREIGN KEY (plan_id)
    REFERENCES tour_plans (plan_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS traveller_feedback (
  feedback_id INT UNSIGNED NOT NULL,
  plan_id INT UNSIGNED NOT NULL,
  message VARCHAR(1000) NOT NULL,
  feedback_status ENUM('New', 'Addressed') NOT NULL DEFAULT 'New',
  submitted_at DATETIME NOT NULL,
  PRIMARY KEY (feedback_id),
  KEY idx_traveller_feedback_plan (plan_id),
  CONSTRAINT fk_traveller_feedback_plan FOREIGN KEY (plan_id)
    REFERENCES tour_plans (plan_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT IGNORE INTO test_table (id, name) VALUES
(1, 'TravelMate record 1'),
(2, 'TravelMate record 2'),
(3, 'TravelMate record 3'),
(4, 'TravelMate record 4'),
(5, 'TravelMate record 5');

-- Five agent records and five traveller records. These display labels are generated.
INSERT IGNORE INTO travel_agents (agent_id, display_name, speciality) VALUES
(1, 'Travel Advisor 1', 'Japan and East Asia'),
(2, 'Travel Advisor 2', 'Portugal and coastal Europe'),
(3, 'Travel Advisor 3', 'India and cultural journeys'),
(4, 'Travel Advisor 4', 'Swiss rail and alpine travel'),
(5, 'Travel Advisor 5', 'Morocco and North Africa');

INSERT IGNORE INTO travellers (traveller_id, display_name, party_size) VALUES
(1, 'Traveller 101', 2),
(2, 'Traveller 102', 2),
(3, 'Traveller 103', 1),
(4, 'Traveller 104', 2),
(5, 'Traveller 105', 3);

INSERT IGNORE INTO tour_plans
(plan_id, reference_code, title, destination, origin, start_date, end_date, status, estimated_total, currency, traveller_id, agent_id, created_at, updated_at) VALUES
(1, 'TM-26001', 'Japan: Tokyo and Kyoto', 'Tokyo, Kyoto, Japan', 'London, United Kingdom', '2027-04-12', '2027-04-17', 'Shared', 3300.00, 'GBP', 1, 1, '2026-11-18 10:00:00', '2026-11-22 15:30:00'),
(2, 'TM-26002', 'Lisbon and the Atlantic Coast', 'Lisbon, Portugal', 'Manchester, United Kingdom', '2027-05-08', '2027-05-13', 'Draft', 2850.00, 'GBP', 2, 2, '2026-11-19 09:15:00', '2026-11-21 12:20:00'),
(3, 'TM-26003', 'Rajasthan Forts and Markets', 'Jaipur, India', 'London, United Kingdom', '2027-11-02', '2027-11-07', 'Approved', 2400.00, 'GBP', 3, 3, '2026-11-08 11:40:00', '2026-11-20 14:10:00'),
(4, 'TM-26004', 'Swiss Lakes by Rail', 'Lucerne, Switzerland', 'Birmingham, United Kingdom', '2027-06-14', '2027-06-19', 'Shared', 4200.00, 'GBP', 4, 4, '2026-11-14 08:25:00', '2026-11-22 16:45:00'),
(5, 'TM-26005', 'Marrakech and the Atlas Foothills', 'Marrakech, Morocco', 'London, United Kingdom', '2027-10-03', '2027-10-08', 'Draft', 3100.00, 'GBP', 5, 5, '2026-11-16 13:05:00', '2026-11-21 10:05:00');

-- Six itinerary days for each plan.
INSERT IGNORE INTO tour_days (day_id, plan_id, day_number, travel_date, city, summary) VALUES
(101, 1, 1, '2027-04-12', 'Tokyo', 'Arrive and settle in'),
(102, 1, 2, '2027-04-13', 'Tokyo', 'Asakusa and old Tokyo'),
(103, 1, 3, '2027-04-14', 'Tokyo', 'Meiji Shrine and Shibuya'),
(104, 1, 4, '2027-04-15', 'Kyoto', 'Rail to Kyoto and Fushimi Inari'),
(105, 1, 5, '2027-04-16', 'Kyoto', 'Arashiyama and Gion'),
(106, 1, 6, '2027-04-17', 'Osaka', 'Travel to Osaka and return'),
(201, 2, 1, '2027-05-08', 'Lisbon', 'Arrive and explore Baixa'),
(202, 2, 2, '2027-05-09', 'Lisbon', 'Alfama and the waterfront'),
(203, 2, 3, '2027-05-10', 'Sintra', 'Historic centre and gardens'),
(204, 2, 4, '2027-05-11', 'Cascais', 'Coastal walk and local lunch'),
(205, 2, 5, '2027-05-12', 'Lisbon', 'Belém and riverside district'),
(206, 2, 6, '2027-05-13', 'Lisbon', 'Free morning and return'),
(301, 3, 1, '2027-11-02', 'Jaipur', 'Arrive and old city walk'),
(302, 3, 2, '2027-11-03', 'Jaipur', 'Amber Fort and hillside views'),
(303, 3, 3, '2027-11-04', 'Jaipur', 'City Palace and observatory'),
(304, 3, 4, '2027-11-05', 'Jaipur', 'Craft quarter and local market'),
(305, 3, 5, '2027-11-06', 'Jaipur', 'Stepwell visit and free time'),
(306, 3, 6, '2027-11-07', 'Jaipur', 'Morning at leisure and return'),
(401, 4, 1, '2027-06-14', 'Lucerne', 'Arrive and lakeside walk'),
(402, 4, 2, '2027-06-15', 'Lucerne', 'Old town and Chapel Bridge'),
(403, 4, 3, '2027-06-16', 'Mount Rigi', 'Mountain railway and viewpoints'),
(404, 4, 4, '2027-06-17', 'Lucerne', 'Lake boat and village visit'),
(405, 4, 5, '2027-06-18', 'Interlaken', 'Scenic rail and town walk'),
(406, 4, 6, '2027-06-19', 'Lucerne', 'Breakfast and return journey'),
(501, 5, 1, '2027-10-03', 'Marrakech', 'Arrive and settle in'),
(502, 5, 2, '2027-10-04', 'Marrakech', 'Medina and historic quarter'),
(503, 5, 3, '2027-10-05', 'Marrakech', 'Gardens and artisan workshops'),
(504, 5, 4, '2027-10-06', 'Atlas foothills', 'Day journey to mountain villages'),
(505, 5, 5, '2027-10-07', 'Marrakech', 'Market visit and free afternoon'),
(506, 5, 6, '2027-10-08', 'Marrakech', 'Morning at leisure and return');

-- One scheduled activity per itinerary day; additional activities can be added later.
INSERT IGNORE INTO activities (activity_id, day_id, start_time, title, location, notes, estimated_cost, currency) VALUES
(1001, 101, '15:00:00', 'Arrival and hotel check-in', 'Tokyo', 'Transfer timing depends on arrival and local conditions.', 0.00, 'GBP'),
(1002, 102, '09:00:00', 'Asakusa neighbourhood walk', 'Asakusa, Tokyo', 'Allow time for local streets and a relaxed lunch.', 25.00, 'GBP'),
(1003, 103, '09:30:00', 'Meiji Shrine and Shibuya', 'Shibuya, Tokyo', 'Travel times are approximate.', 15.00, 'GBP'),
(1004, 104, '08:30:00', 'Rail to Kyoto and Fushimi Inari visit', 'Kyoto', 'Rail arrangements remain proposed until confirmed.', 95.00, 'GBP'),
(1005, 105, '09:00:00', 'Arashiyama and Gion', 'Kyoto', 'Local transport and entry fees are estimates.', 40.00, 'GBP'),
(1006, 106, '10:00:00', 'Travel to Osaka and return journey', 'Osaka', 'Return route and timing require confirmation.', 0.00, 'GBP'),
(2001, 201, '15:00:00', 'Arrival and Baixa orientation walk', 'Baixa, Lisbon', 'A gentle walk after arrival.', 10.00, 'GBP'),
(2002, 202, '09:30:00', 'Alfama and waterfront walk', 'Alfama, Lisbon', 'Route can be adjusted with the agent.', 15.00, 'GBP'),
(2003, 203, '09:00:00', 'Sintra historic centre', 'Sintra, Portugal', 'Transport and admission are estimated.', 65.00, 'GBP'),
(2004, 204, '10:00:00', 'Cascais coastal walk', 'Cascais, Portugal', 'Weather may affect the route.', 20.00, 'GBP'),
(2005, 205, '09:30:00', 'Belém riverside district', 'Belém, Lisbon', 'Optional museum visits are not included.', 25.00, 'GBP'),
(2006, 206, '09:00:00', 'Free morning and departure', 'Lisbon', 'Departure transport is subject to confirmation.', 0.00, 'GBP'),
(3001, 301, '15:00:00', 'Arrival and old city walk', 'Jaipur, India', 'A relaxed introduction to the city.', 10.00, 'GBP'),
(3002, 302, '08:30:00', 'Amber Fort visit', 'Amer, Jaipur', 'Entry and transport estimates may change.', 35.00, 'GBP'),
(3003, 303, '09:00:00', 'City Palace and observatory', 'Jaipur, India', 'Opening times should be checked before travel.', 30.00, 'GBP'),
(3004, 304, '10:00:00', 'Craft quarter and local market', 'Jaipur, India', 'Purchases are not included in the trip estimate.', 15.00, 'GBP'),
(3005, 305, '09:00:00', 'Stepwell visit and free time', 'Jaipur region', 'Local transport estimate only.', 20.00, 'GBP'),
(3006, 306, '09:00:00', 'Morning at leisure and departure', 'Jaipur, India', 'Departure timing requires confirmation.', 0.00, 'GBP'),
(4001, 401, '15:00:00', 'Arrival and lakeside walk', 'Lucerne, Switzerland', 'A relaxed walk after arrival.', 0.00, 'GBP'),
(4002, 402, '09:00:00', 'Old town and Chapel Bridge', 'Lucerne, Switzerland', 'Public areas; optional visits are not included.', 10.00, 'GBP'),
(4003, 403, '08:30:00', 'Mountain railway and viewpoints', 'Mount Rigi, Switzerland', 'Rail fare is an estimate and weather dependent.', 120.00, 'GBP'),
(4004, 404, '09:00:00', 'Lake boat and village visit', 'Lake Lucerne', 'Boat schedule and fare require confirmation.', 90.00, 'GBP'),
(4005, 405, '08:00:00', 'Scenic rail and Interlaken walk', 'Interlaken, Switzerland', 'Rail routing remains proposed.', 110.00, 'GBP'),
(4006, 406, '09:00:00', 'Breakfast and return journey', 'Lucerne, Switzerland', 'Return travel is not booked.', 0.00, 'GBP'),
(5001, 501, '15:00:00', 'Arrival and hotel check-in', 'Marrakech, Morocco', 'Transfer timing depends on arrival.', 0.00, 'GBP'),
(5002, 502, '09:00:00', 'Medina and historic quarter', 'Marrakech, Morocco', 'Respect local customs and opening hours.', 15.00, 'GBP'),
(5003, 503, '09:30:00', 'Gardens and artisan workshops', 'Marrakech, Morocco', 'Workshop purchases are not included.', 30.00, 'GBP'),
(5004, 504, '08:00:00', 'Atlas foothills day journey', 'Atlas foothills, Morocco', 'Route is weather and operator dependent.', 85.00, 'GBP'),
(5005, 505, '09:00:00', 'Market visit and free afternoon', 'Marrakech, Morocco', 'Personal spending is excluded.', 15.00, 'GBP'),
(5006, 506, '09:00:00', 'Morning at leisure and departure', 'Marrakech, Morocco', 'Departure transport requires confirmation.', 0.00, 'GBP');

-- Indicative estimates only. Each set of five cost rows sums to its plan total.
INSERT IGNORE INTO trip_costs (cost_id, plan_id, category, amount, currency, inclusion_note) VALUES
(10001, 1, 'Proposed flights', 1800.00, 'GBP', 'Indicative return flights for two travellers.'),
(10002, 1, 'Accommodation', 750.00, 'GBP', 'Five hotel nights.'),
(10003, 1, 'Rail and local transport', 460.00, 'GBP', 'Proposed intercity rail and local transport.'),
(10004, 1, 'Activities', 210.00, 'GBP', 'Listed activities and estimated entry costs.'),
(10005, 1, 'Planning fee', 80.00, 'GBP', 'Travel planning service estimate.'),
(20001, 2, 'Proposed flights', 980.00, 'GBP', 'Indicative return flights for two travellers.'),
(20002, 2, 'Accommodation', 820.00, 'GBP', 'Five hotel nights.'),
(20003, 2, 'Rail and local transport', 410.00, 'GBP', 'Proposed rail and local transport.'),
(20004, 2, 'Activities', 560.00, 'GBP', 'Listed activities and estimated entry costs.'),
(20005, 2, 'Planning fee', 80.00, 'GBP', 'Travel planning service estimate.'),
(30001, 3, 'Proposed flights', 760.00, 'GBP', 'Indicative return flights for one traveller.'),
(30002, 3, 'Accommodation', 640.00, 'GBP', 'Five hotel nights.'),
(30003, 3, 'Rail and local transport', 390.00, 'GBP', 'Proposed local transport.'),
(30004, 3, 'Activities', 530.00, 'GBP', 'Listed activities and estimated entry costs.'),
(30005, 3, 'Planning fee', 80.00, 'GBP', 'Travel planning service estimate.'),
(40001, 4, 'Proposed flights', 1450.00, 'GBP', 'Indicative return flights for two travellers.'),
(40002, 4, 'Accommodation', 1320.00, 'GBP', 'Five hotel nights.'),
(40003, 4, 'Rail and local transport', 700.00, 'GBP', 'Proposed rail and local transport.'),
(40004, 4, 'Activities', 650.00, 'GBP', 'Listed activities and estimated entry costs.'),
(40005, 4, 'Planning fee', 80.00, 'GBP', 'Travel planning service estimate.'),
(50001, 5, 'Proposed flights', 1150.00, 'GBP', 'Indicative return flights for three travellers.'),
(50002, 5, 'Accommodation', 880.00, 'GBP', 'Five hotel nights.'),
(50003, 5, 'Rail and local transport', 490.00, 'GBP', 'Proposed local transport.'),
(50004, 5, 'Activities', 500.00, 'GBP', 'Listed activities and estimated entry costs.'),
(50005, 5, 'Planning fee', 80.00, 'GBP', 'Travel planning service estimate.');

INSERT IGNORE INTO flight_estimates
(flight_id, plan_id, outbound_route, return_route, departure_date, return_date, estimated_amount, currency, estimate_note) VALUES
(1, 1, 'London to Tokyo', 'Osaka to London', '2027-04-12', '2027-04-17', 1800.00, 'GBP', 'Indicative only; fare and availability are not confirmed.'),
(2, 2, 'Manchester to Lisbon', 'Lisbon to Manchester', '2027-05-08', '2027-05-13', 980.00, 'GBP', 'Indicative only; fare and availability are not confirmed.'),
(3, 3, 'London to Jaipur', 'Jaipur to London', '2027-11-02', '2027-11-07', 760.00, 'GBP', 'Indicative only; fare and availability are not confirmed.'),
(4, 4, 'Birmingham to Zurich', 'Zurich to Birmingham', '2027-06-14', '2027-06-19', 1450.00, 'GBP', 'Indicative only; fare and availability are not confirmed.'),
(5, 5, 'London to Marrakech', 'Marrakech to London', '2027-10-03', '2027-10-08', 1150.00, 'GBP', 'Indicative only; fare and availability are not confirmed.');

-- Video destinations still require a human agent to select and verify a specific public video.
INSERT IGNORE INTO travel_videos (video_id, plan_id, title, video_url, review_status) VALUES
(1, 1, 'Tokyo and Kyoto destination video', NULL, 'Pending'),
(2, 2, 'Lisbon destination video', NULL, 'Pending'),
(3, 3, 'Jaipur destination video', NULL, 'Pending'),
(4, 4, 'Lucerne destination video', NULL, 'Pending'),
(5, 5, 'Marrakech destination video', NULL, 'Pending');

INSERT IGNORE INTO traveller_feedback (feedback_id, plan_id, message, feedback_status, submitted_at) VALUES
(1, 1, 'Please include more time for local food and neighbourhood walks.', 'New', '2026-11-22 14:30:00'),
(2, 2, 'The coastal day looks good; please keep the morning start flexible.', 'Addressed', '2026-11-20 11:10:00'),
(3, 3, 'The updated activity order works for the current itinerary.', 'Addressed', '2026-11-19 16:20:00'),
(4, 4, 'Please clarify which rail legs are included in the estimate.', 'New', '2026-11-22 09:45:00'),
(5, 5, 'Please note the expected walking level for the mountain day.', 'New', '2026-11-21 17:05:00');

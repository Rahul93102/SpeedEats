-- Change delimiter to allow for trigger and procedure creation
DELIMITER //

-- Trigger to update total price in the cart after inserting a new item
CREATE TRIGGER update_cart_price_after_insert
AFTER INSERT ON ecommerceapp_cart_item
FOR EACH ROW
BEGIN
    DECLARE total_price DECIMAL(10, 2);
    
    -- Calculate the total price of all items in the cart
    SELECT SUM(p.price * ci.quantity)
    INTO total_price
    FROM ecommerceapp_cart_item ci
    JOIN ecommerceapp_product p ON ci.product_id = p.id
    WHERE ci.cart_id = NEW.cart_id;
    
    -- Update the total price in the cart table
    UPDATE ecommerceapp_cart
    SET total_price = total_price
    WHERE id = NEW.cart_id;
END //

-- Procedure to block an email for a specified duration
CREATE PROCEDURE block_email(email_to_block VARCHAR(255))
BEGIN
    DECLARE block_time TIMESTAMP;
    SET block_time = NOW() + INTERVAL 30 SECOND;

    -- Insert the email and block_until timestamp into the temporary table
    INSERT INTO blocked_emails (email, block_until) VALUES (email_to_block, block_time);
END //

-- Trigger to block emails after failed login attempts
CREATE TRIGGER after_failed_login
AFTER INSERT ON login_attempts
FOR EACH ROW
BEGIN
    DECLARE email_count INT;
    
    -- Check if the email exists in the database
    SELECT COUNT(*)
    INTO email_count
    FROM users
    WHERE email = NEW.email;

    -- If the email doesn't exist, call the stored procedure to block it
    IF email_count = 0 THEN
        CALL block_email(NEW.email);
    END IF;
END //

-- Trigger to block user login after consecutive failed attempts
CREATE TRIGGER block_user_login
AFTER INSERT ON django_admin_log
FOR EACH ROW
BEGIN
    DECLARE recent_attempts INT;
    DECLARE last_attempt TIMESTAMP;
    DECLARE blocked_until TIMESTAMP;
    
    -- Get the count of recent failed login attempts for the user
    SELECT COUNT(*), MAX(action_time)
    INTO recent_attempts, last_attempt
    FROM django_admin_log
    WHERE action_flag = 1  -- Failed login attempt
    AND username = NEW.username
    AND action_time > NOW() - INTERVAL 1 MINUTE;  -- Within the last minute
    
    -- If three consecutive failed attempts within 1 minute
    IF recent_attempts >= 3 THEN
        -- Set the blocked_until timestamp to 30 seconds from the last attempt
        SET blocked_until = last_attempt + INTERVAL 30 SECOND;

        -- Update the user's record to indicate blocked status
        UPDATE auth_user
        SET is_blocked = 1, blocked_until = blocked_until
        WHERE username = NEW.username;
    END IF;
END //

-- Change delimiter back to semicolon
DELIMITER ;

-- Create a temporary table to track blocked emails
CREATE TEMPORARY TABLE IF NOT EXISTS blocked_emails (
    email VARCHAR(255),
    block_until TIMESTAMP
);

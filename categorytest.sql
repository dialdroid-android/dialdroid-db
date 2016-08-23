-- --------------------------------------------------------------------------------
-- Routine categorytest
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`root`@`localhost` FUNCTION `categorytest`(`intent` INT, `filter` INT) RETURNS tinyint(4)
    NO SQL
BEGIN

DECLARE result TINYINT DEFAULT 1;
DECLARE finished,finished1 INTEGER DEFAULT 0;

declare intent_category,intent_match INT DEFAULT 0;

DECLARE intent_cursor CURSOR for SELECT category from ICategories where intent_id=intent;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;



OPEN intent_cursor;
 
match_categories: LOOP
	FETCH intent_cursor INTO intent_category;
	
  	IF finished = 1 THEN 
 		LEAVE match_categories;
 	END IF;
      
 	
 	BLOCK2: BEGIN
 	
 		DECLARE filter_cursor CURSOR for SELECT category from IFilterCategories  where filter_id=filter and category=intent_category;
		DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished1 = 1;
		OPEN filter_cursor;
		
		match_filters: LOOP
		
		FETCH filter_cursor INTO intent_match;
			
		IF finished1 = 1 THEN
			set result=0; 
 			LEAVE match_filters;
 		END IF;		 		
		
		CLOSE filter_cursor;
		LEAVE match_filters;
		
		END LOOP match_filters;
 	
 	END BLOCK2;
  
END LOOP match_categories;
 
CLOSE intent_cursor;

RETURN  result;


END$$

DELIMITER ;


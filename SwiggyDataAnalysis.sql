USE swiggydata;

select * from swiggy limit 10;


-- 1. Identify High-Rated Restaurants
SELECT COUNT(DISTINCT restaurant_name) AS High_Rated_Restaurants
FROM swiggy 
WHERE rating > 4.5;

-- 2. Top City by Number of Restaurants
SELECT city, COUNT(DISTINCT restaurant_name) AS Restaurant_Count
FROM swiggy 
GROUP BY city 
ORDER BY Restaurant_Count DESC
LIMIT 1;

-- 3. Restaurants Selling Pizza
SELECT COUNT(DISTINCT restaurant_name) AS PIZZA_restaurants
FROM swiggy 
WHERE restaurant_name LIKE '%PIZZA%';

-- 4. Most Common Cuisine
SELECT cuisine, COUNT(*) AS cuisine_count
FROM swiggy
GROUP BY cuisine
ORDER BY cuisine_count DESC
LIMIT 1;

-- 5. Average Rating by City
SELECT city, AVG(rating) AS avg_rating 
FROM swiggy
GROUP BY city;

-- 6. Highest Price in Recommended Menu
SELECT DISTINCT restaurant_name, menu_category, MAX(price) AS highest_price
FROM swiggy
WHERE menu_category = 'RECOMMENDED'
GROUP BY restaurant_name, menu_category
ORDER BY highest_price DESC;

-- 7. Top 5 Expensive Non-Indian Restaurants
SELECT DISTINCT restaurant_name, cost_per_person
FROM swiggy 
WHERE cuisine <> 'Indian'
ORDER BY cost_per_person DESC
LIMIT 5;

-- 8. Restaurants with Above-Average Cost
SELECT DISTINCT restaurant_name, cost_per_person 
FROM swiggy
WHERE cost_per_person > (
    SELECT AVG(cost_per_person) AS avg_cost 
    FROM swiggy
);

-- 9. Restaurants with Same Name in Different Cities
SELECT DISTINCT s1.restaurant_name, s1.city AS city1, s2.city AS city2
FROM swiggy s1
LEFT JOIN swiggy s2 
ON s1.restaurant_name = s2.restaurant_name  
AND s1.city <> s2.city;

-- 10. Restaurant with Most Items in Main Course
SELECT restaurant_name, COUNT(item) AS count_of_items 
FROM swiggy 
WHERE menu_category = 'Main Course'
GROUP BY restaurant_name
ORDER BY count_of_items DESC
LIMIT 1;

-- 11. 100% Vegetarian Restaurants
SELECT DISTINCT restaurant_name, 
(COUNT(CASE WHEN veg_or_nonveg = 'Veg' THEN 1 END) * 100 / COUNT(*)) AS vegetarian_percentage
FROM swiggy 
GROUP BY restaurant_name
HAVING vegetarian_percentage = 100.00
ORDER BY restaurant_name;

-- 12. Restaurant with Lowest Average Price
SELECT DISTINCT restaurant_name, AVG(price) AS Lowest_Average_Price 
FROM swiggy
GROUP BY restaurant_name
ORDER BY Lowest_Average_Price ASC
LIMIT 1;

-- 13. Top 5 Restaurants by Number of Categories
SELECT DISTINCT restaurant_name, COUNT(DISTINCT menu_category) AS No_Of_Category
FROM swiggy 
GROUP BY restaurant_name
ORDER BY No_Of_Category DESC
LIMIT 5;

-- 14. Restaurant with Highest Non-Vegetarian Percentage
SELECT DISTINCT restaurant_name, 
    (COUNT(CASE WHEN veg_or_nonveg = 'Non-veg' THEN 1 END) * 100 / COUNT(*)) AS Nonvegetarian_percentage
FROM swiggy 
GROUP BY restaurant_name
ORDER BY Nonvegetarian_percentage DESC
LIMIT 1;

-- 15. Most and Least Expensive Cities
WITH CityExpense AS (
    SELECT city,
        MAX(cost_per_person) AS max_cost,
        MIN(cost_per_person) AS min_cost
    FROM swiggy
    GROUP BY city
)
SELECT city, max_cost, min_cost
FROM CityExpense
ORDER BY max_cost DESC;

-- 16. Top-Rated Restaurant in Each City
WITH RatingRankByCity AS (
    SELECT DISTINCT
        restaurant_name,
        city,
        rating,
        DENSE_RANK() OVER (PARTITION BY city ORDER BY rating DESC) AS rating_rank
    FROM swiggy
)
SELECT restaurant_name, city, rating, rating_rank
FROM RatingRankByCity
WHERE rating_rank = 1;
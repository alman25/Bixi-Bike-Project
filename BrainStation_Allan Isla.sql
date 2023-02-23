SELECT campaignName, goal, outcome AS Q1_Campaign_Success_by_Goal
FROM campaign
WHERE outcome = 'successful'
ORDER BY goal desc;

SELECT campaignName, goal, outcome AS Q1_Campaign_Failed_by_Goal
FROM campaign
WHERE outcome = 'failed'
ORDER BY goal desc;

SELECT  category.categoryName, category.categoryID, sub_category.subcategory, sub_category.subcategoryID, 
		campaign.campaignName, campaign.sub_category_id, campaign.pledged, campaign.backers
AS Q2_Backers_by_Category
FROM category
JOIN sub_category
	ON category.categoryID = sub_category.category_id
JOIN campaign
	ON sub_category.subcategoryID = campaign.sub_category_id
ORDER BY backers desc;

SELECT  category.categoryName, category.categoryID, sub_category.subcategory, sub_category.subcategoryID, 
		campaign.campaignName, campaign.sub_category_id, campaign.pledged, campaign.backers
AS Q3_and_Q4_Pledged_by_Category
FROM category
JOIN sub_category
	ON category.categoryID = sub_category.category_id
JOIN campaign
	ON sub_category.subcategoryID = campaign.sub_category_id
ORDER BY pledged desc;

Select SUM(campaign.pledged), country.name AS Q5_Pledged_by_Country
FROM country
JOIN campaign
	ON country.id = campaign.country_id
GROUP BY country.name
ORDER BY SUM(campaign.pledged) desc;

Select SUM(campaign.backers), country.name AS Q5_Backed_by_Country
FROM country
JOIN campaign
	ON country.id = campaign.country_id
GROUP BY country.name
ORDER BY SUM(campaign.backers) desc;

SELECT campaign.campaignName, campaign.pledged, campaign.launched, campaign.deadline, 
	   DATEDIFF(campaign.launched, campaign.deadline) AS Q6_date_difference
FROM campaign
ORDER BY pledged asc;
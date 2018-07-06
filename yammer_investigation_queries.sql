/* User Engagement

The query outputs the number of engaged users each week. Yammer defines
engagement  as having made some type of server call by interacting with the
product (shown in the  data as events of type “engagement”). Any point in this
chart can be interpreted as  “the number of users who logged at least one
engagement event during the week starting  on that date.” */

SELECT DATE_TRUNC('week', e.occurred_at),
       COUNT(DISTINCT e.user_id) AS weekly_active_users
FROM tutorial.yammer_events e
WHERE e.event_type = 'engagement'
  AND e.event_name = 'login'
GROUP BY 1
ORDER BY 1 


/*  Devices - Get a list of devices for creating the 'user engagement by device' query */

SELECT DISTINCT e.device AS devices
FROM tutorial.yammer_events e 

/* Output - Devices:

kindle fire macbook pro acer aspire notebook acer aspire desktop lenovo thinkpad
iphone 5s samsung galaxy note mac mini ipad mini nokia lumia 635 nexus 7 nexus
10 samsumg galaxy tablet amazon fire phone dell inspiron desktop dell inspiron
notebook nexus 5 iphone 4s windows surface htc one iphone 5 ipad air macbook air
samsung galaxy s4 asus chromebook hp pavilion desktop

computer: 'macbook pro', 
'acer aspire notebook',
'acer aspire desktop',
'lenovo thinkpad', 
'mac mini', 
'dell inspiron desktop',
'dell inspiron notebook',
'windows surface',
'macbook air',
'asus chromebook',
'hp pavilion desktop' 

tablet: 'kindle fire',
'samsung galaxy note',
'ipad mini',
'nexus 7',
'nexus 10',
'samsumg galaxy tablet',
'nexus 5',
'ipad air' 

phone: 'iphone 5s',
'nokia lumia 635',
'amazon fire phone',
'iphone 4s',
'htc one',
'iphone 5',
'samsung galaxy s4' 
*/ 

/* Plot user engagement by device over time period */

SELECT DATE_TRUNC('week', occurred_at) AS week,
       COUNT(DISTINCT e.user_id) AS weekly_users,
       COUNT(DISTINCT CASE WHEN e.device IN ('macbook pro', 'acer aspire notebook','acer aspire desktop','lenovo thinkpad', 'mac mini', 'dell inspiron desktop','dell inspiron notebook','windows surface','macbook air','asus chromebook','hp pavilion desktop') THEN e.user_id ELSE NULL END) AS computer,
       COUNT(DISTINCT CASE WHEN e.device IN ('iphone 5s','nokia lumia 635','amazon fire phone','iphone 4s','htc one','iphone 5','samsung galaxy s4') THEN e.user_id ELSE NULL END) AS phone,
       COUNT(DISTINCT CASE WHEN e.device IN ('kindle fire','samsung galaxy note','ipad mini','nexus 7','nexus 10','samsumg galaxy tablet','nexus 5','ipad air') THEN e.user_id ELSE NULL END) AS tablet
FROM tutorial.yammer_events e
WHERE e.event_type = 'engagement'
AND e.event_name = 'login'
GROUP BY 1
ORDER BY 1 

/* User Engagement by Mobile Devices only */

SELECT DATE_TRUNC('week', occurred_at) AS week,
       COUNT(DISTINCT e.user_id) AS weekly_users,
       COUNT(DISTINCT CASE WHEN e.device IN ('iphone 5s','nokia lumia 635','amazon fire phone','iphone 4s','htc one','iphone 5','samsung galaxy s4') THEN e.user_id ELSE NULL END) AS phone,
       COUNT(DISTINCT CASE WHEN e.device IN ('kindle fire','samsung galaxy note','ipad mini','nexus 7','nexus 10','samsumg galaxy tablet','nexus 5','ipad air') THEN e.user_id ELSE NULL END) AS tablet
  FROM tutorial.yammer_events e
 WHERE e.event_type = 'engagement'
 GROUP BY 1
 ORDER BY 1 

/* Weekly Engagement Events -  Plot user events
 	'home_page', 'like_page', 'login', 'search_autocomplete', 'search_run', 'send_message', 'view_inbox'
	ADD 'LIKE' **search_click_result_X**
 */
SELECT DATE_TRUNC('week', occurred_at) AS week,
       COUNT(CASE WHEN e.event_name = 'home_page' THEN e.user_id ELSE NULL END) AS home_page,
       COUNT(CASE WHEN e.event_name = 'like_page' THEN e.user_id ELSE NULL END) AS like_page,
       COUNT(CASE WHEN e.event_name = 'login' THEN e.user_id ELSE NULL END) AS login,
       COUNT(CASE WHEN e.event_name = 'search_autocomplete' THEN e.user_id ELSE NULL END) AS search_autocomplete,
       COUNT(CASE WHEN e.event_name = 'search_run' THEN e.user_id ELSE NULL END) AS search_run,
       COUNT(CASE WHEN e.event_name = 'send_message' THEN e.user_id ELSE NULL END) AS send_message,
       COUNT(CASE WHEN e.event_name = 'view_inbox' THEN e.user_id ELSE NULL END) AS view_inbox 
       /* Add "Like" "search_click_result_"  */
FROM tutorial.yammer_events e
WHERE e.event_type = 'engagement'
GROUP BY 1
ORDER BY 1 

/* Weekly Email Engagement by Event Type */
SELECT DATE_TRUNC('week', occurred_at) AS week,
       COUNT(CASE WHEN e.action = 'sent_weekly_digest' THEN e.user_id ELSE NULL END) AS weekly_emails,
       COUNT(CASE WHEN e.action = 'sent_reengagement_email' THEN e.user_id ELSE NULL END) AS reengagement_emails,
       COUNT(CASE WHEN e.action = 'email_open' THEN e.user_id ELSE NULL END) AS email_opens,
       COUNT(CASE WHEN e.action = 'email_clickthrough' THEN e.user_id ELSE NULL END) AS email_clickthroughs
FROM tutorial.yammer_emails e
GROUP BY 1
ORDER BY 1

/* Weekly Event Types - Signup and Engagement */
SELECT DATE_TRUNC('week', occurred_at) AS week,
       COUNT(CASE WHEN e.event_type = 'engagement' THEN e.user_id ELSE NULL END) AS engagement,
       COUNT(CASE WHEN e.event_type = 'signup_flow' THEN e.user_id ELSE NULL END) AS signup
        /* Add "Like" "search_click_result_"  */
  FROM tutorial.yammer_events e
 GROUP BY 1
 ORDER BY 1



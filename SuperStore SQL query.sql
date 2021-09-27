create database superstore;

select * from superstore..SuperStore where Sales=0
delete from superstore..SuperStore where Sales=0;

-- Business Problem--

------Profitability of Superstore in different US States--------------

Select state, 
		sum(Profit) as Profit, 
		sum(Sales) as Total_Sales, 
		sum((Profit/Sales)) as Profit_Ratio, 
		avg(Discount) as Average_Discount,
		sum(quantity) as quantity 
		from superstore..SuperStore group by State order by state;

------------------- Either we can use above which utilized Alias or we can create a new column for profit ratio as below------------------



--------- ----------Creating new column(Feature Engineering/Calculated field) to get Profit Ratio---------------
alter table superstore..SuperStore add Profit_Ratio float;
update superstore..SuperStore set Profit_Ratio = Profit/Sales; 

Select state, 
		sum(Profit) as Profit, 
		sum(Sales) as Total_Sales, 
		sum((Profit_Ratio)) as Profit_Ratio, 
		avg(Discount) as Average_Discount,
		sum(quantity) as quantity 
		from superstore..SuperStore group by State order by state;




--------------Sales and Profit Trend by segments and Product categories---------------------

select * from superstore..SuperStore

--------------- Converting datetime to date type for the column Order Date--------------------------
select DATEPART(year,[Order_date]) from superstore..superstore;

alter table superstore..superstore add Order_date date;
update superstore..superstore set [Order_date] = convert(date,[Order Date]);
alter table superstore..superstore drop column [order date]




-------------------------Sales and Profit Trend by segments ordered year wise-----------------------
Select Segment,Datepart(year,Order_date),sum(sales) as total_sum,sum(profit) as total_profit,sum(Profit_Ratio) as profit_ratio
from superstore..superstore
group by Segment,Datepart(year,Order_date)
order by Segment,Datepart(year,Order_date);

-------------------------Sales and Profit Trend by Category ordered year wise------------------------
Select Category,Datepart(year,Order_date),sum(sales) as total_sum,sum(profit) as total_profit,sum(Profit_Ratio) as profit_ratio
from superstore..superstore
group by Category,Datepart(year,Order_date)
order by Category,Datepart(year,Order_date);





--------------------------------Customer analysis-------------------------
--------------customer ranking basis the sales and color code them basis the Profit Ratio----------------------


select * from superstore..SuperStore
select * from superstore..SalesTarget

select [customer name], segment, sum(Sales) as total_sales, sum(Profit) as Total_profit, sum(Profit_ratio) as profit_ratio from superstore..superstore group by [customer name]

------ Above code is not ideal in SQL as it yeilds a large table and hard to read--------
------- It is best implemented a visualization rather than figures---------------










------------------------------- Sales Performace against Targets----------------------------


select * from superstore..SuperStore
select * from superstore..SalesTarget



---------- Sales Performance againt Sales Targets across all Segments and Category---------------------

select S.Segment,S.Category,Sum(S.Sales) as Total_Sales,Sum(T.[Sales Target]) as Target,IIF((Sum(S.Sales) - Sum(T.[Sales Target]))>=0,'yes','No') as Met_target
		from superstore..SuperStore S 
		join superstore..SalesTarget T 
		on S.[Order_Date] = T.[Order Date] 
		group by S.Segment,S.Category 
		order by S.Segment,S.category

# Overview
Within this notebook, I have analysed data on Google merchandising sales for November 2020 through to January 2021. Throughout, I conduct the sourcing, cleaning and analysing of the sales data to understand the characteristics of the most sold merchandise for Google over this time span.

The data I use is sourced from the [Google Merchandise Sales Data Kaggle Dataset](https://www.kaggle.com/datasets/mexwell/google-merchandise-sales-data), displaying information on the Google Merchandise Store with information on items sold and how much money was spent by users over time. Through the use of both SQL and Python, I have sought to understand the outstanding trends among Google merchandise sales and their key drivers.

# Questions Posed
Below are the questions I want to answer within the project:

1. What are are the general trends for Google merchandising sales, highlighting the data on overall total sales, country-specific sales, and the main devices used. 
2. What are the most sold brands within Google Merchandise Store? 
3. What categories of merchandise attract the most purchases?
4. What are the category share of merchandise within the Google Merchandise Store.
5. What are the most and least sold items of Merchandise, specifying both the brand and category of the items in question.

# Tools Used
- **PostgreSQL:** Used to source and organise the dataset appropriately before beginning the cleaning process in Python.
- **Python:** Used in the cleaning, analysing, and visualisation of the dataset. Throughout this process, I used the following tools:
    - **Pandas:** Used to further sort and clean the database for analysis and visualisation.
    - **Matplotlib:** Used in the visualisation of the datasets.
    - **Seaborn:** Used to create enhanced visualisations that could better display trends within the data.
- **Jupyter Notebooks:** Used in the running of my Python Scripts.
- **Visual Studio Code:** Used to execute Python Scripts.
- **Git & GitHub:** Essential for version control and sharing both my Python code and analysis.

# Data Preparation and Cleanup

## Data Preparation:

1. I made use of PostgreSQL to import the dataset from Kaggle into tables I could work with. 
2. After the data was successfully input into the provided tables, I merged the tables to form one dataset I could work with in Python.

**Example Code:** 

```sql
SELECT
    event.country,
    event.device,
    event.type,
    event.date,
    item.name,
    item.brand,
    item.variant,
    item.category,
    item.price_in_usd,
    userss.ltv,
    userss.date AS user_date

FROM public.events_1 AS event
    LEFT JOIN public.items AS item ON event.item_id = item.id
    LEFT JOIN public.users AS userss ON event.user_id = userss.id;
```
## Data Cleanup:
1. I first check the data within the database to search for any null values. 

**Sample of Code Used:**
```python
sns.heatmap(df.isnull(), cbar=False, cmap='coolwarm')
plt.title("Missing Values in Imported Tables")
plt.xlabel("Columns")
plt.ylabel("Rows")
plt.show()
```
**Visualisation:**

![Heatmap visualisation of null values](Images\null_values_heat_map.png)

*Visualising location of null values within the data through a heat map*

2. After locating null values, variant column is removed given the amount of null values and the country null values are filled.
3. Any duplicated values within the dataset are also removed to avoid repeated data.

# The Analysis

## 1. General Analysis
Within the first section of my analysis, I focus my attention on the highest sales numbers in differing areas, aiming to understand standard trends within the market. 

**Noteworthy Findings:**

![Overall Sales](Images\total_sales_overall.png)

*Trend in total sales over the period under analysis.*

![Leading Countries](Images\leading_countries_sales.png)

*Countries with the most sales made by the Google Merchandise Store.*

#### **Insights:**
- Total sales are at their highest within the middle of december.
- Despite the drop off in overall sales around the end of december, total sales remain relatively higher than those in November.
- The US is the leading country in Google Merchandise sales, attaining around 300,000 more sales than the second leading country.
- The device with the most online purchases for Google Merchandise is the desktop.

## 2. Brand Analysis
For the next step in my analysis, I focus my attention on the brand distribution within total sales.

**Sample of Code Used:**
```python
explode=[0, 0.1, 0.1, 0.2, 0.2]

plt.pie(df_b['count'],
        labels=df_b['brand'], 
        explode=explode, 
        autopct= lambda p: f'{p:.1f}%' if p>5 else'')

plt.title('Brand Representation of Total Sales', fontsize='15')

plt.tight_layout()
plt.show()
```
**Visualisation:**

![Brand Analysis](Images\brand_rep.png)

#### **Insights:** 
- The leading brand within the Google Merchandise store is Google, attaining sales share roughly equivalent to three quarters of the total sales.
- Both #IamRemarkable and Google Cloud amass less than five percent of total sales.

## 3. Category Analysis
When analysing the category of merchandise, I seek to answer the following three questions: 
1. Which categories achieve the highest total sales?
2. What is the change in total sales by category over time?
3. What is the change in the share of total sales by category over time?

### 1. Which categories achieve the highest total sales?

**Sample of Code Used:**
```python
df_ca = df['category'].value_counts().sort_values(ascending=False).copy()
df_ca = df_ca.reset_index(name= 'count')

plt.figure(figsize=(12,6))

sns.barplot(df_ca, x='category', y='count', hue='count', palette='viridis_r', zorder=2)
sns.despine()
```
**Visualisation:**

![Category Total](Images\category_sales_count.png)

#### **Insights:**
- Apparel is by far the most popular category in the number of total sales, amassing around 200,000 more sales than the second highest category.

### Additional Question: "What is the average price of the most popular category?"

Using a histplot, I seek to find out the average price that consumers pay for Apparel as the most popular category.

**Visualisation:**

![Histogram](Images\hist_cat.png)

#### **Insights:**
- On average, it appears that the average price for merchandise in the apparel category is around 10 to 60 dollars.
- There are the odd items in Apparel which are sold for over 100 dollars.

### 2. What is the change in total sales by category over time?

In this section I look at the top 5 categories ranked by total sales and sought to analyse trends in their sales over the given data time period.

**Sample of Code Used:**
```python
dfc = df.copy()
dfc['month_year'] = dfc['date'].dt.strftime('%Y-%m')
dfc_pivot = dfc.pivot_table(index="month_year", columns='category', aggfunc='size', fill_value=0)
dfc_pivot.loc['total'] = dfc_pivot.sum()
dfc_pivot = dfc_pivot[dfc_pivot.loc['total'].sort_values(ascending=False).index]
dfc_pivot = dfc_pivot.drop('total')
dfc_pivot = dfc_pivot.reset_index()
dfc_pivot['month_no'] = dfc_pivot['month_year'].apply(lambda x: pd.to_datetime(x, format='%Y-%m').strftime('%b'))
dfc_pivot = dfc_pivot.set_index('month_no')
```
**Visualisation:**

![Top 5 category tot over time](Images\top_5_cat.png)

*Change in total sales for the top 5 categories over the three months.*

#### **Insights:**
- All categories experience an uptick in total sales around December, which corresponds well with the overarching trends on total sales shown previously.
- Apparel remains the category with the top total sales throughout all three periods.

### 3. What is the change in the share of total sales by category over time?
I then look into this change in the relative share of total sales over this time period.

**Visualisation:**

![Top 5 cat share](Images\percent_total_share.png)

*Change in top 5 categories percentage share of total sales over time*

#### **Insights:**
- Both the Apparel and New categories are experiencing a slight decrease in total share while Accessories and Shop by Brand are experiencing slight share increases. 
- Given the relatively short period of time in which this data has been gathered, it can't be concluded that these trends will follow for the coming months.

## 4. Merchandise Analysis
I finally focus my attention to the specific merchandise with the highest and lowest total sales. I will then look into the shared characteristics of the merchandise in both ranks. Given my previous findings, I should expect to find merchandise with the most total sales branded under Google in the Apparel category.

### Highest and Lowest Selling Merchandise: Accounting for Characteristics

**Sample of Code Used:**
```python
f_rbc = df.groupby(['name','brand','category'])['price_in_usd'].agg('sum').sort_values(ascending=True).reset_index(name='revenue')
df_rbcbottom = df_rbc.sort_values(by='revenue', ascending=True).head(10)
df_rbctop = df_rbc.sort_values(by='revenue', ascending=False).head(10)
df_rbcbottom = df_rbcbottom.sort_values(by='revenue', ascending=False)
fig, ax = plt.subplots(3, 1, figsize=(12,12))
sns.despine()
sns.barplot(df_rtop, x='name', y='revenue', ax=ax[0], hue='revenue', palette='dark:b_r', zorder=2)
sns.barplot(df_rbctop, x='name', y='revenue', ax=ax[1], hue='brand', palette='magma', zorder=2)
sns.barplot(df_rbctop, x='name', y='revenue', ax=ax[2], hue='category', palette='viridis', zorder=2)
```
**Visualisations:**

![Top merch](Images\high_rev_merch.png)

*Highest revenue generating merchandise, shown first by revenue generated, followed by the merchandises brand and category association.*

![Bot merch](Images\low_rev_merch.png)

*Lowest revenue generating merchandise, shown first by revenue generated, followed by the merchandises brand and category association.*

#### **Insights:**
- As expected the highest revenue generating merchandise appear to be all under the brand of Google, while almost all the Merchandise is categorised under Apparel, upholding our previous findings.
- For the lowest revenue generating merchandise, there is slightly more variety in the brand, switching between Google and Android, with much more variation in the Category. Given the high concentration of sales in Apparel it would make sense that the lowest revenue generating merchandise is mostly a mix of the other categories.

# What I learnt 
Throughout the project, there were many skills I was able to strengthen throughout the manipulation of this dataset.

- **Improved Data Cleaning:** Using innovative methods such as producing heatmaps to spot the number of null values, better helps me see what columns can be cleaned and which ones need to be removed, helping speed up the cleaning process.
- **Improved Data Visualisation:** Visualising both the change in total sales by category and change in relative share of each category took a lot of work. I needed to come up with new ways to present the data so as to send a clear message.
- **Honing In on Trends:** Throughout the analysis, I was able to find characteristics within the data that supported the previous trends I had found in the data. This made the latest discoveries more coherent given previous findings.

# Insights

The project presented three main insights:

- **Sales and Time:** The point at which total sales were seen to be highest was around mid-December. This correlated well with total sales findings by category later in the analysis.
- **Top Selling Merchandise:** It appears that the Merchandise with the highest revenue generated aligned with previous findings, showing that most merchandise of this type were branded under Google in the Apparel category.
- **Lowest Selling Merchandise:** Given that the highest revenue generating merchandise was mostly Google brands in the Apparel category, it made sense to find out the lowest revenue generating merchandise had both a mix of brands with no clear majority in the category type.

# Challenges I've Faced
Throughout the project, I faced the following challenges

- **Percentage Representation:** I found that visualising data in a percentage format took a lot more work. For one, the data-frames had to be altered significantly before being able to display the data.
- **Merchandise Subplotting:** Finding a way to represent both the revenue generated by specific merchandise and their given characteristics was at first difficult to understand. This definitely tested my knowledge on manipulating subplots.

# Conclusion
Throughout this project, I have been pushed to strengthen my skills in data sourcing, cleaning, and analysis to provide visualisations that could easily explain my findings. Throughout my analysis, I discovered that the category with the most sales is Apparel and the brand associated with the most sales is Google. My findings were finally confirmed when analysing the characteristics of the highest revenue generating merchandise, finding that most were branded under Google and were categorised as Apparel. This project helped me scan through sales data and effectively analyse the characteristics of Google merchandise that sells well.
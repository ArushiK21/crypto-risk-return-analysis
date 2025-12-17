# Cryptocurrency Risk Analysis – VaR, ES, GARCH & EVT

Assessing the financial risk characteristics of cryptocurrency returns using a range of quantitative methods, including Value at Risk (VaR), Expected Shortfall (ES), GARCH modelling, and Extreme Value Theory (EVT).

---

## 1. Project Overview

This project evaluates the risk profile of cryptocurrency returns using both standard and advanced risk measurement techniques. 

Cryptocurrency markets are known for:

- High volatility  
- Non-normal return distributions  
- Pronounced tail risk and extreme events  

This repository implements an academic assignment on assessing the financial risk characteristics of cryptocurrency returns. The analysis is carried out using an Excel-based database, standard risk measures such as Value at Risk (VaR) and Expected Shortfall (ES), and advanced tail modelling with Extreme Value Theory (EVT). A GARCH-EVT approach and the FindTheTail tool are used to capture and analyse extreme events in cryptocurrency markets. 

---

## 2. Objectives

The main objectives of this assignment are:

1. **Review theory and literature** on financial risk measurement, VaR, ES, GARCH models, and Extreme Value Theory with a focus on cryptocurrencies.
2. **Collect and organize data** for selected cryptocurrencies from reputable sources.
3. **Construct a clean database** (in Excel) for further analysis.
4. **Perform basic risk assessment**, including descriptive statistics and computation of VaR and ES.
5. **Test iid assumptions** and, when appropriate, apply a **GARCH-EVT approach** to model time-varying volatility and tail risk.
6. **Apply EVT using FindTheTail** (external EVT tool) and compare EVT-based risk measures to more standard approaches.

---

## 3. Assignment Workflow

This repository reflects the following workflow:

1. **Read article and relevant literature**  
   - Background on VaR, ES, GARCH models, and EVT.  
   - Empirical studies on cryptocurrency risk and tail behavior.

2. **Gather necessary data**  
   - Download historical price data for selected cryptocurrencies from:  
     - [coingecko.com](https://www.coingecko.com)  
     - [coinmarketcap.com](https://coinmarketcap.com)  
     - [messari.io](https://messari.io)  
   - Define:
     - Sample period (From 01/11/2022 to 05/11/2025)  
     - Frequency (daily prices)  
     - Assets (CurveDAO, Uniswap, PancakeSwap, Pendle, Raydium)
    
After downloading the price data, prices are aligned on a common calendar, missing values are handled (e.g., by removing days where not all assets have observations), and simple or log returns are computed from the cleaned price series.

3. **Create Excel database**  
   - Store cleaned price data in a structured Excel file:  
     - Consistent date format  
     - One sheet or table per asset or a combined panel  
   - Compute **log returns** or simple returns in Excel or via code and store them in the same workbook.
The cleaned prices and corresponding return series are stored in `DEX Data Database.xlsx`. 


4. **Basic risk assessment and computation of VaR/ES**  
   - Compute descriptive statistics for returns:  
     - Mean, standard deviation, skewness, kurtosis  
   - Estimate risk measures:  
     - Historical VaR at chosen confidence levels (e.g., 95%, 99%)  
     - Historical Expected Shortfall (ES) at the same levels  
   - Visualize distributions (histograms, boxplots, etc.) to illustrate volatility and tail behavior.

5. **Extreme Value Theory – Test for iid**  
   - Check the iid assumption of returns using:  
     - Autocorrelation and partial autocorrelation plots  
     - Ljung–Box or similar tests  
   - If returns are not iid, proceed with a **GARCH-EVT approach**.

6. **GARCH-EVT approach**  
   - Fit a suitable GARCH-type model (e.g., GARCH(1,1)) to returns.  
   - Extract standardized residuals from the fitted model.  
   - Apply EVT (e.g., Peaks-Over-Threshold approach) to the residuals to model tail behavior.  
   - Derive VaR/ES estimates based on the EVT model and compare them with historical/parametric results.

7. **Apply Extreme Value Theory via FindTheTail**  
   - Use **FindTheTail** (EVT tool) to:  
     - Identify appropriate thresholds  
     - Fit tail distributions  
     - Estimate tail-based risk measures (e.g., EVT-based VaR and ES).  
   - Compare FindTheTail results with the in-code EVT implementation (if applicable) and with basic historical VaR/ES.

---

## 4. Data Description

- **Assets**: Selected major cryptocurrencies (CurveDAO, Uniswap, PancakeSwap, Pendle, Raydium).  
- **Frequency**: Typically daily closing prices. daily prices
- **Period**: To be specified (From 01/11/2022 to 05/11/2025).  
- **Sources**:
  - CoinGecko  
  - CoinMarketCap  
  - Messari  

After downloading:

- Convert prices to **returns** (preferably log returns).  
- Handle missing values (drop or interpolate with clear justification).  
- Ensure all assets share a common date range.

---

## 5. Methods & Risk Measures

The project applies the following methods:

### 5.1 Descriptive Statistics
- Mean, standard deviation (volatility)  
- Minimum and maximum returns  
- Skewness and kurtosis to detect asymmetry and fat tails  

### 5.2 Value at Risk (VaR) and Expected Shortfall (ES)
- **Historical VaR**: Percentile of empirical return distribution  
- **Historical ES**: Average loss beyond the VaR threshold  
- (Optional) **Parametric VaR/ES** using normal or t-distributed returns

### 5.3 Extreme Value Theory (EVT)
- Focus on extreme returns (tails of the distribution).  
- Threshold selection and tail modelling.  
- EVT-based estimates of VaR and ES at high confidence levels.

### 5.4 GARCH-EVT
- GARCH modelling of conditional volatility to remove time-varying volatility effects.  
- Application of EVT to standardized residuals.  
- Comparison of GARCH-EVT risk estimates with basic historical methods.

### 5.5 EVT via FindTheTail
- Use FindTheTail to:
  - Systematically identify tail regions  
  - Fit tail distributions  
  - Obtain additional EVT-based risk metrics  
- Use results as a cross-check for EVT work done in Excel or code.

---

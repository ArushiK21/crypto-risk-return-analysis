# Cryptocurrency Risk Analysis – VaR, ES, GARCH & EVT

Assessing the financial risk characteristics of cryptocurrency returns using a range of quantitative methods, including Value at Risk (VaR), Expected Shortfall (ES), GARCH modelling, and Extreme Value Theory (EVT).

---

## 1. Project Overview

This project evaluates the risk profile of cryptocurrency returns using both standard and advanced risk measurement techniques. 

Cryptocurrency markets are known for:

- High volatility  
- Non-normal return distributions  
- Pronounced tail risk and extreme events  

The aim is to quantify and better understand these risk characteristics using historical data and modern risk modelling tools.

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
     - Sample period (start and end dates)  
     - Frequency (e.g., daily prices)  
     - Assets (e.g., BTC, ETH, etc.)

3. **Create Excel database**  
   - Store cleaned price data in a structured Excel file:  
     - Consistent date format  
     - One sheet or table per asset or a combined panel  
   - Compute **log returns** or simple returns in Excel or via code and store them in the same workbook.

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

- **Assets**: Selected major cryptocurrencies (e.g., BTC, ETH, and others as defined in the assignment).  
- **Frequency**: Typically daily closing prices.  
- **Period**: To be specified (e.g., from YYYY-MM-DD to YYYY-MM-DD).  
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

## 6. Repository Structure

*(Adjust this to match your actual files.)*

```text
.
├── data/
│   ├── raw/                 # Raw downloads from CoinGecko, CoinMarketCap, Messari
│   └── processed/           # Cleaned data and Excel database with returns
├── excel/
│   └── crypto_risk_database.xlsx   # Main Excel database
├── notebooks/
│   ├── 01_data_preparation.ipynb   # Import, cleaning, return calculation
│   ├── 02_basic_risk_analysis.ipynb # Descriptive stats, VaR, ES
│   ├── 03_evt_and_iid_tests.ipynb   # EVT setup, iid tests, residual diagnostics
│   └── 04_garch_evt.ipynb           # GARCH modelling and EVT on residuals
├── figures/
│   └── ...                   # Plots for distributions, tails, and risk estimates
├── report/
│   └── crypto_risk_report.pdf # Final written assignment (if applicable)
├── requirements.txt          # Python dependencies (if using Python)
└── README.md                 # Project documentation

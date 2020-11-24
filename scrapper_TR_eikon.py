# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""
import pandas as pd
import warnings
import eikon as ek
import datetime
ek.set_app_key('38fe2ce1f1c047da82efa5ef3c33ea765c469cca')

#ETF que nous avons choisi
ETF_RIC = ['SPY.N', 'VOO.N','IVV.N']
#tickers = ['ESV', 'MKTX', 'HSIC', 'NVR', 'SWKS', 'ALXN', 'AOS', 'DISCK', 'ZTS', 'AWK', 'GPN', 'ETSY', 'ALB', 'AYE', 'LYV', 'NCLH', 'HLT', 'KHC', 'TRIP', 'HII', 'SLG', 'TDC', 'KORS', 'CNC', 'GMCR', 'JNPR', 'EVRG', 'SBAC', 'MGM', 'KFT', 'WPX', 'DG', 'AAP', 'RE', 'INFO', 'JBHT', 'CHTR', 'DAL', 'CHD', 'CXO', 'JKHY', 'CRM', 'ARG', 'UAL', 'ABBV', 'HBI', 'NFX', 'MHK', 'GME', 'QEP', 'NAVI', 'LYB', 'ICE', 'PNR', 'REG', 'DLPH', 'CERN', 'FOSL', 'TEL', 'HRL', 'GGP', 'ADS', 'AME', 'BLK', 'TWTR', 'JEC', 'LO', 'O', 'JOY', 'INCY', 'COO', 'NWS', 'GM', 'MXIM', 'FL', 'VTR', 'VRSK', 'NFLX', 'RRC', 'TDY', 'NKTR', 'HOLX', 'COV', 'FTV', 'GRMN', 'IPGP', 'FRC', 'CTLT', 'MAA', 'AAL', 'TDG', 'ROL', 'LW', 'JDSU', 'EVHC', 'POOL', 'GDI', 'FANG', 'WLTW', 'VRTX', 'MNST', 'PYPL', 'MSCI', 'FBHS', 'FB', 'MPC', 'WAB', 'QRVO', 'IEX', 'LKQ', 'PETM', 'DRE', 'CVC', 'FTNT', 'TYL', 'ABK', 'VNT', 'AVB', 'OTIS', 'CARR', 'ARNC', 'DXCM', 'PRGO', 'CPGX', 'ALK', 'XYL', 'GAS', 'LNT', 'URI', 'CTVA', 'NOW', 'CE', 'AJG', 'CSRA', 'STX', 'ATVI', 'REGN', 'WCG', 'CBOE', 'FFIV', 'AMG', 'LRCX', 'CMG', 'ILMN', 'CPRT', 'MOS', 'DISH', 'ACN', 'HFC', 'CMCSK', 'PCLN', 'OI', 'EXR', 'WST', 'TER', 'DPZ', 'UA', 'ATO', 'FRT', 'ESS', 'CB', 'SNPS', 'EQIX', 'ALLE', 'RIG', 'ANET', 'V', 'HRS', 'ODFL', 'MNK', 'STZ', 'RJF', 'ANSS', 'FOX', 'AVGO', 'MAC', 'XEC', 'CLF', 'AMD', 'IT', 'BMS', 'TSCO', 'BHF', 'DOW', 'ZBRA', 'TMUS', 'FLT', 'PSX', 'IR', 'AYI', 'FAST', 'UHS', 'TFX', 'WRB', 'BIO', 'FOXA', 'TYC', 'NLSN', 'LDOS', 'PKG', 'CDW', 'RCL', 'KMX', 'EXPE', 'KSU', 'DLR', 'SIG', 'BWA', 'ESRX', 'PAYC', 'RMD', 'ENDP', 'MLM', 'DXC', 'ANR', 'LVS', 'KRFT', 'TSO', 'CBE', 'STE', 'SBL', 'DLTR', 'SYF', 'ARE', 'ABMD', 'MTD', 'HCA', 'CFG', 'MJN', 'CDNS', 'KMI', 'TTWO', 'CCI', 'Q', 'GOOGL', 'HPE', 'KEYS', 'BXLT', 'COTY', 'EW', 'LVLT', 'ADT', 'HP', 'PVH', 'INTU', 'SAIC', 'LUK', 'ULTA', 'YHOO', 'ALGN', 'SIVB', 'UDR', 'IDXX', 'BR']
tickers = ['AAL.OQ', 'AAP.N', 'ABBV.N', 'ABMD.OQ', 'ACN.N', 'ADS.N', 'AIZ.N',
       'AJG.N', 'AKAM.OQ', 'ALB.N', 'ALGN.OQ', 'ALK.N', 'ALLE.N',
       'ALXN.OQ', 'AME.N', 'AMT.N', 'ANET.N', 'ANSS.OQ', 'AOS.N', 'APH.N',
       'APTV.N', 'ARE.N', 'ATO.N', 'ATVI.OQ', 'AVB.N', 'AVGO.OQ', 'AWK.N']

tickers_1 =['BKNG.OQ', 'BLK.N', 'BR.N', 'BRKb.N', 'BWA.N', 'BXP.N', 'CBOE.Z',
       'CBRE.N', 'CCI.N', 'CDNS.OQ', 'CDW.OQ', 'CE.N', 'CERN.OQ', 'CF.N',
       'CFG.N', 'CHD.N', 'CHRW.OQ', 'CHTR.OQ', 'CME.OQ', 'CMG.N', 'CNC.N',
       'COG.N', 'COO.N', 'COTY.N', 'CPRI.N', 'CPRT.OQ', 'CRM.N',
       'CTSH.OQ', 'CTVA.N', 'CXO.N', 'DAL.N', 'DD.N', 'DFS.N', 'DG.N']

tickers_2=['DISCA.OQ', 'DISCK.OQ', 'DISH.OQ', 'DLR.N', 'DLTR.OQ', 'DOW.N',
       'DRE.N', 'DVA.N', 'EL.N', 'EQIX.OQ', 'ES.N', 'ESS.N', 'EVRG.N',
       'EW.N', 'EXPD.OQ', 'EXPE.OQ', 'EXR.N', 'FANG.OQ', 'FAST.OQ',
       'FB.OQ', 'FBHS.N', 'FFIV.OQ', 'FIS.N', 'FLIR.OQ', 'FLS.N', 'FLT.N',
       'FMC.N', 'FOX.OQ', 'FOXA.OQ', 'FRC.N', 'FRT.N', 'FTNT.OQ', 'FTV.N',
       'GM.N']

tickers_3=['GOOG.OQ', 'GOOGL.OQ', 'GPN.N', 'GRMN.OQ', 'HBI.N',
       'HCA.N', 'HFC.N', 'HII.N', 'HLT.N', 'HOLX.OQ', 'HP.N', 'HPE.N',
       'HRL.N', 'HSIC.OQ', 'HST.OQ', 'ICE.N', 'IDXX.OQ', 'IEX.N',
       'ILMN.OQ', 'INCY.OQ', 'INFO.N', 'IPGP.OQ', 'IQV.N', 'IRM.N',
       'ISRG.OQ', 'IT.N', 'IVZ.N', 'J.N', 'JBHT.OQ', 'JKHY.OQ', 'JNPR.N',
       'KEYS.N', 'KHC.OQ', 'KIM.N', 'KMI.N', 'KMX.N', 'KSU.N', 'LHX.N',
       'LKQ.OQ']

tickers_4=['LNT.OQ', 'LRCX.OQ', 'LVS.N', 'LYB.N', 'LYV.N', 'MA.N',
       'MAA.N', 'MCHP.OQ', 'MDLZ.OQ', 'MGM.N', 'MHK.N', 'MKTX.OQ',
       'MLM.N', 'MNST.OQ', 'MOS.N', 'MPC.N', 'MSCI.N', 'MTD.N', 'MXIM.OQ',
       'NBL.OQ^J20', 'NCLH.N', 'NDAQ.OQ', 'NFLX.OQ', 'NLSN.N', 'NOW.N',
       'NRG.N', 'NVR.N', 'NWS.OQ', 'NWSA.OQ', 'O.N', 'ODFL.OQ', 'OKE.N']
tickers_5=['ORLY.OQ', 'PBCT.OQ', 'PEAK.N', 'PKG.N', 'PLD.N', 'PM.N', 'PNR.N',
       'PRGO.N', 'PSX.N', 'PVH.N', 'PWR.N', 'PXD.N', 'PYPL.OQ', 'QRVO.OQ','RCL.N', 'RE.N', 'REG.OQ', 'REGN.OQ', 'RJF.N', 'RL.N', 'RMD.N',
       'ROL.N', 'ROP.N', 'ROST.OQ', 'RSG.N', 'SBAC.OQ', 'SIVB.OQ',
       'SJM.N', 'SLG.N', 'SNPS.OQ', 'STE.N', 'STX.OQ', 'SWKS.OQ', 'SYF.N']

tickers_6=['TDG.N', 'TFX.N', 'TSCO.OQ', 'TTWO.OQ', 'TWTR.N', 'UA.N', 'UAA.N',
       'UAL.OQ', 'UDR.N', 'UHS.N', 'ULTA.OQ', 'URI.N', 'V.N', 'VAR.N',
       'VRSK.OQ', 'VRSN.OQ', 'VRTX.OQ', 'VTR.N', 'WAB.N', 'WCG.N^A20',
       'WDC.OQ', 'WEC.N', 'WELL.N', 'WLTW.OQ', 'WRB.N', 'WRK.N', 'WU.N',
       'WYNN.OQ', 'XEC.N', 'XRAY.OQ', 'XYL.N', 'ZBRA.OQ', 'ZTS.N']

#définir les dates que nous voulons
Dates = []
start="2006-01-01"
end="2019-12-31"

#liste de tickr
#df=pd.read_excel('data_stock_price.xlsx')
#symbols=df.iloc[0]
#dfsymbols=symbols.to_frame()
#dfsymbols.columns = ['a']
#dfsymbols2 = dfsymbols.iloc[1:]
#a=dfsymbols2['a'].array
#tickr=list(set(a)) #remove duplicate
#print(len(tickers))
#construire alogo avec les dates + merge la database
"""
2 databases:
    - Companies 
    - ETF
"""
#Obtain compostion of ETF

#for value in ETF_RIC:
    #etf_holding = ek.get_data(value,'TR.ETPConstituentName', {'SDate': '2018-01-01'})
   # print(etf_holding)
   # df_holding= etf_holding[0]
  #  df_holding.head()
  #  df_holding.to_excel("etf_holding.xlsx")  
    
# algo to obtain PE and EV/EBIT
#companies_pe = ek.get_data(tickers,["TR.EVToEBITDA",'TR.PE'], parameters={'SDate': start,'EDate':end})
#df_pe=companies_pe[0]
#df_pe.to_excel('companies_PE.xlsx')
#print(companies_pe)


#Obtenir les stocks qui constituent le S&P500

#constituants_SP,err = ek.get_data(instruments=['.SPX'], fields=["TR.IndexConstituentRIC","TR.IndexConstituentName"], parameters={'SDate': start,'EDate':end})
#constituants_SP.set_index('Instrument', inplace=True)
#constituants_SP.head()
#constituants_SP.to_excel('constituant.xlsx')

#constituants_SP_change,err = ek.get_data(instruments=['.SPX'], fields=['TR.IndexJLConstituentChangeDate','TR.IndexJLConstituentRIC.change','TR.IndexJLConstituentRIC','TR.IndexJLConstituentName'], parameters={'SDate': start,'EDate':end, 'IC':'L'})
#constituants_SP_change.set_index('Date', inplace=True)
#constituants_SP_change_j,err = ek.get_data(instruments=['.SPX'], fields=['TR.IndexJLConstituentChangeDate','TR.IndexJLConstituentRIC.change','TR.IndexJLConstituentRIC','TR.IndexJLConstituentName'], parameters={'SDate': start,'EDate':end, 'IC':'J'})
#constituants_SP_change_j.set_index('Date', inplace=True)
#tickers = constituants_SP_change["Constituent RIC"]
#constituants_SP_change.to_excel("leaver.xlsx")
#constituants_SP_change_j.to_excel("joiner.xlsx")
#print(tickers)
#result = pd.merge(constituants_SP_change,constituants_SP_change_j,on="Date")
#tickers = result["Constituent RIC_x"]
#tickers.append(result["Constituent RIC_y"])
#tickers = list(dict.fromkeys(tickers))
#print(tickers)
#result.to_excel('constituant_change.xlsx')
#constituants_SP,err = ek.get_data(instruments=['FB'], fields=["TR.IncomeAftTaxMarginpct(period=FY0)"], parameters={'SDate':'2020-01-01'})
#constituants_SP.set_index('Instrument', inplace=True)
#constituants_SP.head()
#df_constituants.to_excel('constisutant.xlsx')
#print(constituants_SP)

#return_stock,err= ek.get_data(instruments='FB.OQ', fields=["TR.CompanyName","TR.PriceClose.date","TR.PriceClose",'TR.PE',"TR.ROEMean","TR.Volume","TR.EBITDA","TR.NetProfitMargin"], parameters={'SDate': start,'EDate':end,"Frq":"FQ"})
#data_stock,err= ek.get_data(instruments=tickers_6, fields=["TR.CompanyName","TR.PriceClose.date","TR.PriceClose",'TR.PE',"TR.ROEMean","TR.Volume","TR.CompanyMarketCap",'TR.ASKPRICE','TR.BIDPRICE'], parameters={'SDate': start,'EDate':end})
#data_stock.to_excel("data_stock_7.xlsx")
#data_stock2,err= ek.get_data(instruments=tickers_1, fields=["TR.CompanyName","TR.PriceClose.date","TR.PriceClose",'TR.PE',"TR.ROEMean","TR.Volume","TR.CompanyMarketCap",'TR.ASKPRICE','TR.BIDPRICE'], parameters={'SDate': start,'EDate':end})
#data_stock2.to_excel("data_stock_2.xlsx")
#choper les net asset values
SPY_nav,err = ek.get_data(ETF_RIC  ,fields=["TR.Volume.date","TR.Volume"],parameters={'SDate': start,'EDate':end})
date_start = datetime.datetime(year=2006, month=1, day=1)
date_end = datetime.datetime(year=2019, month=12, day=31)
#SPY_nav,err = ek.get_timeseries(['DIA.N', 'SPY.N'], ['VOLUME'],interval="daily")

print(type(SPY_nav))
SPY_nav.set_index('Instrument', inplace=True)
SPY_nav.head()
SPY_nav.to_excel('etf_data_volume.xlsx')


#ETF SMI
#cssmi_nav = ek.get_timeseries(["CSSMI.S"], start_date = start,end_date = end, interval="daily")
#print(cssmi_nav)
#cssmi_nav.to_excel('SPY_Nav.xlsx')


#S&P
#sp_500 = ek.get_timeseries("=TR(".SPX", "HST_CLOSE"), start_date = start,
#end_date = end, interval="daily")
#print(cssmi_nav)
#cssmi_nav.to_excel('SPY_Nav.xlsx')




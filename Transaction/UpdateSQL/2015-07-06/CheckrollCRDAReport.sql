/****** Object:  StoredProcedure [Checkroll].[CRDAReport]    Script Date: 7/7/2015 6:48:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [Checkroll].[CRDAReport] @EstateID          NVARCHAR(50), 
                                         @ActiveMonthYearID NVARCHAR(50) 
AS 
  BEGIN 
      SELECT c_da.estateid, 
             g_estate.estatename, 
             c_da.activemonthyearid, 
             c_gm.gangname, 
             c_da.rdate, 
             c_emp.empcode, 
             c_emp.empname, 
             c_as.attendancecode, 
             Isnull(c_otd.ot1, 0)                  AS ot1, 
             Isnull(c_otd.ot2, 0)                  AS ot2, 
             Isnull(c_otd.ot3, 0)                  AS ot3, 
             Isnull(c_otd.ot4, 0)                  AS ot4, 
             g_amy.amonth, 
             g_amy.ayear, 
             c_emp .category, 
             (SELECT ( Isnull(c_as_totalhk .timesbasic, 0) ) 
              FROM   checkroll.dailyattendance  AS c_da  
                     LEFT JOIN checkroll.attendancesetup AS c_as_totalhk 
                       ON c_da.attendancesetupid = 
                          c_as_totalhk.attendancesetupid
						  AND ( c_as_totalhk.attendancecode = '11' 
                                 OR c_as_totalhk.attendancecode = '51' 
                                 OR c_as_totalhk.attendancecode = 'J1'
								 OR c_as_totalhk.attendancecode = '56'
								 OR c_as_totalhk.attendancecode = '55'
								 OR c_as_totalhk.attendancecode = '54'
								 OR c_as_totalhk.attendancecode = '53'
								 OR c_as_totalhk.attendancecode = '52'   ) 
              WHERE  c_da.empid = c_emp.empid 
                     AND c_da .estateid = c_dta .estateid 
                     AND c_da.rdate = c_dta.ddate) AS totalhk, 
             (SELECT totalabsent =1 
              FROM   checkroll.dailyattendance AS c_da 
                     INNER JOIN checkroll.attendancesetup AS c_as_absent 
                       ON c_da.attendancesetupid = c_as_absent.attendancesetupid 
                          AND (c_as_absent.attendancecode = 'AB' 
                          OR c_as_absent.attendancecode = 'S0'
                           OR c_as_absent.attendancecode = 'SG'
                            OR c_as_absent.attendancecode = 'I0'
							OR c_as_absent.attendancecode = 'TP'
							OR c_as_absent.attendancecode = 'TP1'
							OR c_as_absent.attendancecode = 'TP2'
							OR c_as_absent.attendancecode = 'TP3'
							OR c_as_absent.attendancecode = 'MT')
              WHERE  c_da.empid = c_emp.empid 
                     AND c_da .estateid = c_dta .estateid 
                     AND c_da.rdate = c_dta.ddate) AS totalabsent, 
             (SELECT totalabsent =1 
              FROM   checkroll.dailyattendance AS c_da 
                     INNER JOIN checkroll.attendancesetup AS c_as_sick 
                       ON c_da.attendancesetupid = c_as_sick.attendancesetupid 
                          AND ( c_as_sick.attendancecode = 'S1' 
                                 OR c_as_sick.attendancecode = 'S2' 
                                 OR c_as_sick.attendancecode = 'S3' 
                                 OR c_as_sick.attendancecode = 'S4' 
                                 OR c_as_sick.attendancecode = 'CD' ) 
              WHERE  c_da.empid = c_emp.empid 
                     AND c_da .estateid = c_dta .estateid 
                     AND c_da.rdate = c_dta.ddate) AS totalsick, 
             (SELECT totalabsent =1 
              FROM   checkroll.dailyattendance AS c_da 
                     INNER JOIN checkroll.attendancesetup AS c_as_offday 
                       ON c_da.attendancesetupid = c_as_offday.attendancesetupid 
                          AND ( c_as_offday.attendancecode = 'L0' 
                                 OR c_as_offday.attendancecode = 'L1'
                                 OR c_as_offday.attendancecode = 'JL' ) 
              WHERE  c_da.empid = c_emp.empid 
                     AND c_da .estateid = c_dta .estateid 
                     AND c_da.rdate = c_dta.ddate) AS totaloffday, 
             (SELECT totalabsent =1 
              FROM   checkroll.dailyattendance AS c_da 
                     INNER JOIN checkroll.attendancesetup AS c_as_sunday 
                       ON c_da.attendancesetupid = c_as_sunday.attendancesetupid 
                          AND ( c_as_sunday.attendancecode = 'M0' 
                                 OR c_as_sunday.attendancecode = 'M1' ) 
              WHERE  c_da.empid = c_emp.empid 
                     AND c_da .estateid = c_dta .estateid 
                     AND c_da.rdate = c_dta.ddate) AS totalsunday, 
             (SELECT totalabsent =1 
              FROM   checkroll.dailyattendance AS c_da 
                     INNER JOIN checkroll.attendancesetup AS c_as_leave 
                       ON c_da.attendancesetupid = c_as_leave.attendancesetupid 
                          AND ( c_as_leave.attendancecode = 'CB' 
                                 OR c_as_leave.attendancecode = 'CH' 
                                 OR c_as_leave.attendancecode = 'CT' 
                                 OR c_as_leave.attendancecode = 'I1' 
                                 OR c_as_leave.attendancecode = 'I2') 
              WHERE  c_da.empid = c_emp.empid 
                     AND c_da .estateid = c_dta .estateid 
                     AND c_da.rdate = c_dta.ddate) AS totalleave, 
             (SELECT totalabsent =1 
              FROM   checkroll.dailyattendance AS c_da 
                     INNER JOIN checkroll.attendancesetup AS c_as_rain 
                       ON c_da.attendancesetupid = c_as_rain.attendancesetupid 
                          AND c_as_rain.attendancecode = 'H1' 
              WHERE  c_da.empid = c_emp.empid 
                     AND c_da .estateid = c_dta .estateid 
                     AND c_da.rdate = c_dta.ddate) AS totalrain 
      FROM   checkroll.dailyattendance AS c_da 
             INNER JOIN checkroll.cremployee AS c_emp 
               ON c_da.empid = c_emp.empid 
             LEFT JOIN checkroll.otdetail AS c_otd 
               ON c_da.empid = c_otd.empid 
                  AND c_da.rdate = c_otd.adate 
             INNER JOIN checkroll.dailyteamactivity AS c_dta 
               ON c_da.dailyteamactivityid = c_dta.dailyteamactivityid 
                  AND c_da.rdate = c_dta.ddate 
             INNER JOIN checkroll.gangmaster AS c_gm 
               ON c_dta.gangmasterid = c_gm.gangmasterid 
             INNER JOIN checkroll.attendancesetup AS c_as 
               ON c_da.attendancesetupid = c_as.attendancesetupid 
                  AND c_da.estateid = c_as.estateid 
             INNER JOIN general.estate AS g_estate 
               ON c_da.estateid = g_estate.estateid 
             INNER JOIN general.activemonthyear AS g_amy 
               ON c_da.activemonthyearid = g_amy.activemonthyearid 
      WHERE  c_da.estateid = @EstateID 
             AND c_da.activemonthyearid = @ActiveMonthYearID 
      ORDER  BY c_gm.gangname, 
                c_emp.empcode, 
                c_da.rdate 
  END 

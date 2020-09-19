RS = {}

-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!!!!!!!DIT IS EEN ARRAY DIE DOORTELT!!!!!!!!!!!!
-- !!!!NIEUWE DEUREN HELEMAAL ONDERAAN TOEVOEGEN!!!!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
RS.Doors = {
	--
	-- Mission Row First Floor
	--
	-- Entrance Doors
	{
		textCoords = vector3(434.81, -981.93, 30.89),
		authorizedJobs = { 'police' },
		locking = false,
		locked = false,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = 'v_ilev_ph_door01',
				objYaw = -90.0,
				objCoords = vector3(434.7, -980.6, 30.8)
			},

			{
				objName = 'v_ilev_ph_door002',
				objYaw = -90.0,
				objCoords = vector3(434.7, -983.2, 30.8)
			}
		}
	},
	-- To locker room & roof
	{
		objName = 'v_ilev_ph_gendoor004',
		objYaw = 90.0,
		objCoords  = vector3(449.6, -986.4, 30.6),
		textCoords = vector3(450.09, -986.92, 30.68),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},
	-- Rooftop
	{
		objName = 'v_ilev_gtdoor02',
		objYaw = 90.0,
		objCoords  = vector3(464.3, -984.6, 43.8),
		textCoords = vector3(464.38, -983.64, 43.8),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},
	-- Hallway to roof
	{
		objName = 'v_ilev_arm_secdoor',
		objYaw = 90.0,
		objCoords  = vector3(461.2, -985.3, 30.8),
		textCoords = vector3(461.34, -986.283, 30.8),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},
	-- Armory
	{
		objName = 'v_ilev_arm_secdoor',
		objYaw = -90.0,
		objCoords  = vector3(452.6, -982.7, 30.6), 
		textCoords = vector3(452.95, -982.16, 30.99),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},
	-- Captain Office
	{
		objName = 'v_ilev_ph_gendoor002',
		objYaw = -180.0,
		objCoords  = vector3(447.2, -980.6, 30.6),
		textCoords = vector3(447.61, -979.9, 30.7),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},
	-- To downstairs (double doors)
	{
		textCoords = vector3(444.71, -989.43, 30.92),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		doors = {
			{
				objName = 'v_ilev_ph_gendoor005',
				objYaw = 180.0,
				objCoords = vector3(443.9, -989.0, 30.6)
			},

			{
				objName = 'v_ilev_ph_gendoor005',
				objYaw = 0.0,
				objCoords = vector3(445.3, -988.7, 30.6)
			}
		}
	},
	--
	-- Mission Row Cells
	--
	-- Main Cells
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = 0.0,
		objCoords  = vector3(463.8, -992.6, 24.9),
		textCoords = vector3(463.3, -992.6, 25.1),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
	},
	-- Cell 1
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = -90.0,
		objCoords  = vector3(462.3, -993.6, 24.9),
		textCoords = vector3(461.8, -993.3, 25.0),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
	},
	-- Cell 2
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = 90.0,
		objCoords  = vector3(462.3, -998.1, 24.9),
		textCoords = vector3(461.8, -998.8, 25.0),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
	},
	-- Cell 3
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = 90.0,
		objCoords  = vector3(462.7, -1001.9, 24.9),
		textCoords = vector3(461.8, -1002.4, 25.0),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
	},
	-- To Back
	{
		objName = 'v_ilev_gtdoor',
		objYaw = 0.0,
		objCoords  = vector3(464.61, -1003.64, 24.98),
		textCoords = vector3(464.61, -1003.64, 24.98),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
	},
	--
	-- Mission Row Back
	--
	-- Back (double doors)
	{
		textCoords = vector3(468.67, -1014.43, 26.48),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = 'v_ilev_rc_door2',
				objYaw = 0.0,
				objCoords  = vector3(467.3, -1014.4, 26.5)
			},

			{
				objName = 'v_ilev_rc_door2',
				objYaw = 180.0,
				objCoords  = vector3(469.9, -1014.4, 26.5)
			}
		}
	},
	-- Back Gate
	{
		objName = 'hei_prop_station_gate',
		objYaw = 90.0,
		objCoords  = vector3(488.8, -1017.2, 27.1),
		textCoords = vector3(488.8, -1020.2, 30.0),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 14,
		size = 2
	},
	--
	-- Mission Row Extension
	--
	-- Briefing room
	{
		textCoords = vector3(455.86, -981.31, 26.86),
		authorizedJobs = { 'police' },
		locking = false,
		locked = false,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = 'v_ilev_ph_gendoor005',
				objYaw = 90.0,
				objCoords  = vector3(455.94, -980.57, 26.67)
			},

			{
				objName = 'v_ilev_ph_gendoor005',
				objYaw = 270.0,
				objCoords  = vector3(455.85, -982.14, 26.67)
			}
		}
	},
	-- To Breakrooms
	{
		objName = 'v_ilev_ph_gendoor005',
		objYaw = 90.0,
		objCoords  = vector3(465.62, -985.93, 25.74),
		textCoords = vector3(465.62, -985.93, 25.74),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
	},
	-- New Cell 1
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = 180.0,
		objCoords  = vector3(468.57, -999.44, 25.07),
		textCoords = vector3(468.57, -999.44, 25.07),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
	},
	-- New Cell 2
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = 180.0,
		objCoords  = vector3(472.16, -999.47, 25.05),
		textCoords = vector3(472.16, -999.47, 25.05),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
	},
	-- New Cell 3
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = 180.0,
		objCoords  = vector3(476.4, -1007.68, 24.41),
		textCoords = vector3(476.4, -1007.68, 24.41),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
	},
	-- New Cell 4
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = 180.0,
		objCoords  = vector3(480.0, -1007.7, 24.41),
		textCoords = vector3(480.0, -1007.7, 24.41),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
	},
	-- To Photoroom
	{
		objName = 'v_ilev_ph_gendoor006',
		objYaw = 0.0,
		objCoords  = vector3(475.05, -995.08, 24.46),
		textCoords = vector3(475.05, -995.08, 24.46),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
	},
	-- To Standplace
	{
		objName = 'v_ilev_ph_gendoor006',
		objYaw = 180.0,
		objCoords  = vector3(485.71, -996.08, 24.45),
		textCoords = vector3(485.71, -996.08, 24.45),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
	},
	-- To Interigation 1
	{
		objName = 'v_ilev_ph_gendoor005',
		objYaw = 180.0,
		objCoords  = vector3(484.63, -999.74, 24.46),
		textCoords = vector3(484.63, -999.74, 24.46),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
	},
	-- To Interigation 2
	{
		objName = 'v_ilev_ph_gendoor005',
		objYaw = 180.0,
		objCoords  = vector3(491.37, -999.81, 24.46),
		textCoords = vector3(491.37, -999.81, 24.46),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
	},
	-- To Evidence
	{
		objName = 'v_ilev_ph_gendoor005',
		objYaw = 180.0,
		objCoords  = vector3(470.78, -992.21, 25.12),
		textCoords = vector3(470.78, -992.21, 25.12),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
	},
	
	-- Bureau Paleto Bay
	{
		textCoords = vector3(-435.57, 6008.76, 27.98),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = 'v_ilev_ph_gendoor002',
				objYaw = -135.0,
				objCoords = vector3(-436.5157, 6007.844, 28.13839),			
			},
			{
				objName = 'v_ilev_ph_gendoor002',
				objYaw = 45.0,
				objCoords = vector3(-434.6776, 6009.681, 28.13839)			
			}
		}
	},	
	-- Achterdeur links
	{
		objName = 'v_ilev_rc_door2',
		objYaw = 135.0,
		objCoords  = vector3(-450.9664, 6006.086, 31.99004),		
		textCoords = vector3(-451.38, 6006.55, 31.84),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
	},
	-- Achterdeur rechts
	{
		objName = 'v_ilev_rc_door2',
		objYaw = -45.0,
		objCoords  = vector3(-447.2363, 6002.317, 31.84003),		
		textCoords = vector3(-446.77, 6001.84, 31.68),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
	},
	-- Kleedkamer
	{
		objName = 'v_ilev_rc_door2',
		objYaw = -45.0,
		objCoords  = vector3(-450.7136, 6016.371, 31.86523),				
		textCoords = vector3(-450.15, 6015.96, 31.71),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
	},	
	-- Kleedkamer 2
	{
		objName = 'v_ilev_rc_door2',
		objYaw = 45.0,
		objCoords  = vector3(-454.0435, 6010.243, 31.86106),						
		textCoords = vector3(-453.56, 6010.73, 31.71),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
	},	
	-- Wapenkamer
	{
		objName = 'v_ilev_arm_secdoor',
		objYaw = -135.0,
		objCoords  = vector3(-439.1576, 5998.157, 31.86815),						
		textCoords = vector3(-438.64, 5998.51, 31.71), 
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
	},	
	-- Verhoorkamer
	{
		objName = 'v_ilev_arm_secdoor',
		objYaw = 45.0,
		objCoords  = vector3(-436.6276, 6002.548, 28.14062),							
		textCoords = vector3(-437.09, 6002.100, 27.98),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
	},
	-- Entree cellen 1
	{
		objName = 'v_ilev_ph_cellgate1',
		objYaw = 45.0,
		objCoords  = vector3(-438.228, 6006.167, 28.13558),							
		textCoords = vector3(-438.610, 6005.64, 27.98),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
	},
	-- Entree cellen 2
	{
		objName = 'v_ilev_ph_cellgate1',
		objYaw = 45.0,
		objCoords  = vector3(-442.1082, 6010.052, 28.13558),							
		textCoords = vector3(-442.55, 6009.61, 27.98),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
	},	
	-- Cel
	{
		objName = 'v_ilev_ph_cellgate1',
		objYaw = 45.0,
		objCoords  = vector3(-444.3682, 6012.223, 28.13558),								
		textCoords = vector3(-444.77, 6011.74, 27.98),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
	},						
	-- Gang lockers (dubbele deuren)
	{
		textCoords = vector3(-442.09, 6011.93, 31.86523),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = 'v_ilev_rc_door2',
				objYaw = 225.0,
				objCoords  = vector3(-441.0185, 6012.795, 31.86523),			
			},

			{
				objName = 'v_ilev_rc_door2',
				objYaw = 45.0,
				objCoords  = vector3(-442.8578, 6010.958, 31.86523)			
			}
		}
	},	
	-- Gang naar achterkant (dubbele deuren)
	{
		textCoords = vector3(-448.67, 6007.52, 31.86523),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = 'v_ilev_rc_door2',
				objYaw = 135.0,
				objCoords = vector3(-447.7283, 6006.702, 31.86523),				
			},

			{
				objName = 'v_ilev_rc_door2',
				objYaw = -45.0,
				objCoords = vector3(-449.5656, 6008.538, 31.86523)		
			}
		}
	},				
	--
	-- Bolingbroke Penitentiary
	--
	-- Entrance (Two big gates)
	{
		objName = 'prop_gate_prison_01',
		objCoords  = vector3(1844.9, 2604.8, 44.6),
		textCoords = vector3(1844.9, 2608.5, 48.0),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 13,
		size = 2
	},
	{
		objName = 'prop_gate_prison_01',
		objCoords  = vector3(1818.5, 2604.8, 44.6),
		textCoords = vector3(1818.5, 2608.4, 48.0),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 13,
		size = 2
	},
	{
		objName = 'prop_gate_prison_01',
		objCoords = vector3(1799.237, 2616.303, 44.6),
		textCoords = vector3(1795.941, 2616.969, 48.0),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 10,
		size = 2
	},
	-- Entrance 
	{
		objName = 'v_ilev_gtdoor',
		objYaw = 90.0,
		objCoords  = vector3(1845.3, 2585.87, 45.98),
		textCoords = vector3(1845.3, 2585.87, 45.98),
		authorizedJobs = { 'police' },
		locking = false,
		locked = false,
		pickable = false,
		distance = 2,
		size = 2
	},
	-- Visitor door 
	{
		objName = 'v_ilev_gtdoor',
		objYaw = 360.0,
		objCoords  = vector3(1834.753, 2579.517, 46.04625),
		textCoords = vector3(1834.753, 2579.517, 46.04625),
		authorizedJobs = { 'police' },
		locking = false,
		locked = false,
		pickable = false,
		distance = 2,
		size = 2
	},
	--Lobby Cell Door
	{
		objName = 'bobo_prison_cellgate',
		objCoords  = vector3(1838.603, 2588.299, 45.95181),
		textCoords = vector3(1838.56, 2588.15, 45.89181),
		authorizedJobs = {'police'},
		locking = false,
		locked = false,
		pickable = false,
		distance = 2,
		size = 2
	},
	--  Changingroom
	{
		objName = 'v_ilev_gtdoor',
		objYaw = 270.0,
		objCoords  = vector3(1841.56, 2593.55, 45.89),
		textCoords = vector3(1841.56, 2593.55, 45.89),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},
	-- To Hallway
	{
		objName = 'bobo_prison_cellgate',
		objCoords  = vector3(1836.61, 2593.69, 45.95),
		textCoords = vector3(1836.61, 2593.69, 45.95),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},
	-- To Mid hallway
	{
		objName = 'bobo_prison_cellgate',
		objCoords  = vector3(1831.50, 2593.95, 45.95),
		textCoords = vector3(1831.50, 2593.95, 45.95),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},
	-- Hallway to Visitor
	{
		objName = 'bobo_prison_cellgate',
		objCoords  = vector3(1829.857, 2591.666, 45.95518),
		textCoords = vector3(1829.847, 2591.696, 45.89166),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},
	-- Hallway to outside
	{
		objName = 'v_ilev_gtdoor',
		objYaw = 270.0,
		objCoords  = vector3(1819.1, 2594.26, 45.89),
		textCoords = vector3(1819.1, 2594.26, 45.89),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},
	-- To Main lobby
	{
		textCoords = vector3(1791.05, 2593.78, 46.15),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		doors = {
			{
				objName = 'v_ilev_gtdoor',
				objYaw = 270.0,
				objCoords = vector3(1791.12, 2594.44, 46.15),				
			},

			{
				objName = 'v_ilev_gtdoor',
				objYaw = 90.0,
				objCoords = vector3(1791.11, 2593.10, 46.15)		
			}
		}
	},				
	-- Mainhall to outside
	{
		objName = 'v_ilev_gtdoor',
		objYaw = 180.0,
		objCoords  = vector3(1785.65, 2600.11, 46.15),
		textCoords = vector3(1785.65, 2600.11, 46.15),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},

	-- To Isolation room
	{
		objName = 'v_ilev_gtdoor',
		objYaw = 270.0,
		objCoords  = vector3(1782.60, 2598.22, 45.75),
		textCoords = vector3(1782.60, 2598.22, 45.75),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},

	-- Entrance to Cell block
	{
		objName = 'bobo_prison_cellgate',
		objCoords  = vector3(1782.59200, 2591.895, 45.77614),
		textCoords = vector3(1782.70200, 2591.935, 45.72614),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		size = 2
	},
	-- Isolation room
	-- Cell 1
	{
		objName = 'bobo_prison_isolated_gate',
		objYaw = 360.0,
		objCoords  = vector3(1779.898, 2597.126, 45.83871),
		textCoords = vector3(1779.96, 2597.11, 45.72),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
		size = 2
	},
	-- Cell 2
	{
		objName = 'bobo_prison_isolated_gate',
		objYaw = 360.0,
		objCoords  = vector3(1776.96, 2597.123, 45.83838),
		textCoords = vector3(1777.02, 2597.11, 45.83838),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
		size = 2
	},
	-- Cell 3
	{
		objName = 'bobo_prison_isolated_gate',
		objYaw = 360.0,
		objCoords  = vector3(1774.008, 2597.116, 45.83894),
		textCoords = vector3(1774.078, 2597.156, 45.83894),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
		size = 2
	},
	-- Cell 4
	{
		objName = 'bobo_prison_isolated_gate',
		objYaw = 270.0,
		objCoords  = vector3(1772.604, 2598.686, 45.8366),
		textCoords = vector3(1772.620, 2598.620, 45.8389),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
		size = 2
	},
	--outside doors
	{
		objName = 'prop_fnclink_03gate5',
		objYaw = 180.0,
		objCoords = vector3(1796.322, 2596.574, 45.565),
		textCoords = vector3(1796.322, 2596.574, 45.965),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},
	{
		objName = 'prop_fnclink_03gate5',
		objYaw = 180.0,
		objCoords = vector3(1796.322, 2591.574, 45.565),
		textCoords = vector3(1796.322, 2591.574, 45.965),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},
	{
		objName = 'v_ilev_gtdoor',
		objCoords = vector3(1821.677, 2477.265, 45.945),
		textCoords = vector3(1821.677, 2477.265, 45.945),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},
	{
		objName = 'v_ilev_gtdoor',
		objCoords = vector3(1760.692, 2413.251, 45.945),
		textCoords = vector3(1760.692, 2413.251, 45.945),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},
	{
		objName = 'v_ilev_gtdoor',
		objCoords = vector3(1543.58, 2470.252, 45.945),
		textCoords = vector3(1543.58, 2470.25, 45.945),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},
	{
		objName = 'v_ilev_gtdoor',
		objCoords = vector3(1659.733, 2397.475, 45.945),
		textCoords = vector3(1659.733, 2397.475, 45.945),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},
	{
		objName = 'v_ilev_gtdoor',
		objCoords = vector3(1537.731, 2584.842, 45.945),
		textCoords = vector3(1537.731, 2584.842, 45.945),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},
	{
		objName = 'v_ilev_gtdoor',
		objCoords  = vector3(1571.964, 2678.354, 45.945),
		textCoords = vector3(1571.964, 2678.354, 45.945),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},
	{
		objName = 'v_ilev_gtdoor',
		objCoords  = vector3(1650.18, 2755.104, 45.945),
		textCoords = vector3(1650.18, 2755.104, 45.945),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},
	{
		objName = 'v_ilev_gtdoor',
		objCoords  = vector3(1771.98, 2759.98, 45.945),
		textCoords = vector3(1771.98, 2759.98, 45.945),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},
	{
		objName = 'v_ilev_gtdoor',
		objCoords  = vector3(1845.7, 2699.79, 45.945),
		textCoords = vector3(1845.7, 2699.79, 45.945),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},
	{
		objName = 'v_ilev_gtdoor',
		objCoords  = vector3(1820.68, 2621.95, 45.945),
		textCoords = vector3(1820.68, 2621.95, 45.945),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},
	----------------
	-- Pacific Bank
	----------------
	-- First Door
	{
		objName = 'hei_v_ilev_bk_gate_pris',
		objCoords  = vector3(257.41, 220.25, 106.4),
		textCoords = vector3(257.41, 220.25, 106.4),
		authorizedJobs = { 'police' },
		objYaw = -20.0,
		locking = false,
		locked = true,
		pickable = true,
		distance = 1.5,
		size = 2
	},
	-- Second Door
	{
		objName = 'hei_v_ilev_bk_gate2_pris',
		objCoords  = vector3(261.83, 221.39, 106.41),
		textCoords = vector3(261.83, 221.39, 106.41),
		authorizedJobs = { 'police' },
		objYaw = -110.0,
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
		size = 2
	},
	-- Office to gate door
	{
		objName = 'v_ilev_bk_door',
		objCoords  = vector3(265.19, 217.84, 110.28),
		textCoords = vector3(265.19, 217.84, 110.28),
		authorizedJobs = { 'police' },
		objYaw = -20.0,
		locking = false,
		locked = true,
		pickable = true,
		distance = 1.5,
		size = 2
	},

	-- First safe Door
	{
		objName = 'hei_v_ilev_bk_safegate_pris',
		objCoords  = vector3(252.98, 220.65, 101.8),
		textCoords = vector3(252.98, 220.65, 101.8),
		authorizedJobs = { 'police' },
		objYaw = 160.0,
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
		size = 2
	},
	-- Second safe Door
	{
		objName = 'hei_v_ilev_bk_safegate_pris',
		objCoords  = vector3(261.68, 215.62, 101.81),
		textCoords = vector3(261.68, 215.62, 101.81),
		authorizedJobs = { 'police' },
		objYaw = -110.0,
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
		size = 2
	},

	----------------
	-- Fleeca Banks
	----------------
	-- Door 1
	{
		objName = 'v_ilev_gb_vaubar',
		objCoords  = vector3(314.61, -285.82, 54.49),
		textCoords = vector3(313.3, -285.45, 54.49),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 1.5,
		size = 2
	},
	-- Door 2
	{
		objName = 'v_ilev_gb_vaubar',
		objCoords  = vector3(148.96, -1047.12, 29.7),
		textCoords = vector3(148.96, -1047.12, 29.7),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 1.5,
		size = 2
	},
	-- Door 3
	{
		objName = 'v_ilev_gb_vaubar',
		objCoords  = vector3(-351.7, -56.28, 49.38),
		textCoords = vector3(-351.7, -56.28, 49.38),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 1.5,
		size = 2
	},
	-- Door 4
	{
		objName = 'v_ilev_gb_vaubar',
		objCoords  = vector3(-2956.18, -335.76, 38.11),
		textCoords = vector3(-2956.18, -335.76, 38.11),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 1.5,
		size = 2
	},
	-- Door 5
	{
		objName = 'v_ilev_gb_vaubar',
		objCoords  = vector3(-2956.18, 483.96, 16.02),
		textCoords = vector3(-2956.18, 483.96, 16.02),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 1.5,
		size = 2
	},
	-- Paleto Door 1
	{
		objName = 'v_ilev_cbankvaulgate01',
		objCoords  = vector3(-105.77, 6472.59, 31.81),
		textCoords = vector3(-105.77, 6472.59, 31.81),
		objYaw = 45.0,
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
		size = 2
	},
	-- Paleto Door 2
	{
		objName = 'v_ilev_cbankvaulgate02',
		objCoords  = vector3(-106.26, 6476.01, 31.98),
		textCoords = vector3(-105.5, 6475.08, 31.99),
		objYaw = -45.0,
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
		size = 2
	},
	-----
	-- Police front gate
	-----
	{
		objName = 'prop_facgate_07b',
		objYaw = -90.0,
		objCoords  = vector3(419.99, -1025.0, 28.99),
		textCoords = vector3(419.9, -1021.04, 30.5),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 20,
		size = 2
	},
	-----
	-- Luxury Cars
	-----
	-- Entrance Doors 
	{
		textCoords = vector3(-803.0223, -223.8222, 37.87975),
		authorizedJobs = { 'cardealer', 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 3.5,
		doors = {
			{
				objName = 'prop_doorluxyry2',
				objYaw = 120.0,
				objCoords = vector3(-803.0223, -222.5841, 37.87975)
			},

			{
				objName = 'prop_doorluxyry2',
				objYaw = -60.0,
				objCoords = vector3(-801.9622, -224.5203, 37.87975)			
			}
		}
	},	
	-- Side Entrance Doors 
	{
		textCoords = vector3(-777.1855, -244.0013, 37.333889),
		authorizedJobs = { 'cardealer', 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 3.5,
		doors = {
			{
				objName = 'prop_doorluxyry',				
				objYaw = -160.0,
				objCoords = vector3(-778.1855, -244.3013, 37.33388)
			},

			{
				objName = 'prop_doorluxyry',
				objYaw = 23.0,
				objCoords = vector3(-776.1591, -243.5013, 37.33388)				
			}
		}
	},	
	-- Garage Doors
	{
		textCoords = vector3(-768.1264, -238.9737, 37.43247),
		authorizedJobs = { 'cardealer', 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 13.0,
		doors = {
			{
				objName = 'prop_autodoor',
				objCoords = vector3(-770.6311, -240.0069, 37.43247)    
			},

			{
				objName = 'prop_autodoor',
				objCoords = vector3(-765.6217, -237.9405, 37.43247) 		
			}
		}
	},		
	----------------
	-- Maestro Rental
	----------------
	-- Voordeur 1
	{
		objName = 'apa_prop_apa_cutscene_doorb',
		objCoords  = vector3(-21.71276, -1392.778, 29.63847),		
		textCoords = vector3(-22.31276, -1392.778, 29.63847),
		authorizedJobs = { 'rental' },
		objYaw = -180.0,
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		size = 2
	},	
	-- Voordeur 2
	{
		objName = 'apa_prop_apa_cutscene_doorb',
		objCoords  = vector3(-32.67987, -1392.064, 29.63847),		
		textCoords = vector3(-32.10987, -1392.064, 29.63847),
		authorizedJobs = { 'rental' },
		objYaw = 0.0,
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		size = 2
	},	
	-- Deur naar kelder
	{
		objName = 'apa_prop_apa_cutscene_doorb',
		objCoords  = vector3(-24.22668, -1403.067, 29.63847),				
		textCoords = vector3(-24.22668, -1402.537, 29.63847),
		authorizedJobs = { 'rental' },
		objYaw = 90.0,
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
		size = 2
	},	
	-- Achterdeur
	{
		objName = 'apa_prop_apa_cutscene_doorb',
		objCoords  = vector3(-21.27107, -1406.845, 29.63847),			
		textCoords = vector3(-21.27107, -1406.245, 29.63847),
		authorizedJobs = { 'rental' },
		objYaw = 90.0,
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},		
	-- Roldeur
	{
		objName = 'prop_com_gar_door_01',
		objCoords  = vector3(-21.04025, -1410.734, 30.51094),			
		textCoords = vector3(-21.04025, -1410.734, 30.51094),
		authorizedJobs = { 'rental' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 7.5,
		size = 2
	},
	----------------
	-- Reporter building
	----------------
	-- Voordeuren
	{
		textCoords = vector3(-1082.297, -259.71, 38.1867),
		authorizedJobs = { 'reporter' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = 'v_ilev_fb_door01',
				objYaw = 28.0,
				objCoords = vector3(-1083.62, -260.416, 38.18)
			},
			{
				objName = 'v_ilev_fb_door02',
				objYaw = 28.0,
				objCoords = vector3(-1080.974, -259.020, 38.18)
			}
		}
	},
	-- -- Achtedeuren
	{
		textCoords = vector3(-1045.818, -230.68, 39.43794),
		authorizedJobs = { 'reporter' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = 'v_ilev_fb_doorshortl',
				objYaw = -243.0,
				objCoords = vector3(-1045.12, -232.004, 39.43794)
			},
			{
				objName = 'v_ilev_fb_doorshortr',
				objYaw = -243.0,
				objCoords = vector3(-1046.516, -229.3581, 39.43794)
			}
		}
	},
	-- zijdeur
	{
		objName = 'v_ilev_gtdoor02',
		objCoords  = vector3(-1042.518, -240.6915, 38.11796),		
		textCoords = vector3(-1041.804, -240.6915, 38.11796),
		authorizedJobs = { 'reporter' },
		objYaw = 28.0,
		locking = false,
		locked = true,
		pickable = false,
		distance = 7.5,
		size = 2
	},
	-- HOSPITAL
	-- DUBBELE DEUR 1
	{
		textCoords = vector3(313.0346, -572.3839, 43.2841),
		authorizedJobs = { 'police', 'ambulance' },
		locking = false,
		locked = false,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = 'gabz_pillbox_doubledoor_l',
				objYaw = 340.0,
				objCoords = vector3(312.4186, -571.9518, 43.2841)
			},
			{
				objName = 'gabz_pillbox_doubledoor_r',
				objYaw = 340.0,
				objCoords = vector3(313.8146, -572.4988, 43.2841)
			}
		}
	},
	-- DUBBELE DEUR 2
	{
		textCoords = vector3(318.7802, -574.5489, 43.2841),
		authorizedJobs = { 'police', 'ambulance' },
		locking = false,
		locked = false,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = 'gabz_pillbox_doubledoor_l',
				objYaw = 340.0,
				objCoords = vector3(318.3313, -574.1353, 43.2841)
			},
			{
				objName = 'gabz_pillbox_doubledoor_r',
				objYaw = 340.0,
				objCoords = vector3(319.6115, -574.491, 43.2841)
			}
		}
	},
	-- DUBBELE DEUR 3
	{
		textCoords = vector3(324.1619, -576.7534, 43.2841),
		authorizedJobs = { 'police', 'ambulance' },
		locking = false,
		locked = false,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = 'gabz_pillbox_doubledoor_l',
				objYaw = 340.0,
				objCoords = vector3(323.5222, -576.136, 43.2841)
			},
			{
				objName = 'gabz_pillbox_doubledoor_r',
				objYaw = 340.0,
				objCoords = vector3(325.1437, -576.5668, 43.2841)
			}
		}
	},
	-- DUBBELE DEUR 4
	{
		textCoords = vector3(317.4712, -578.3271, 43.2841),
		authorizedJobs = { 'police', 'ambulance' },
		locking = false,
		locked = false,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = 'gabz_pillbox_doubledoor_l',
				objYaw = 160.0,
				objCoords = vector3(318.2804, -578.6685, 43.2841)
			},
			{
				objName = 'gabz_pillbox_doubledoor_r',
				objYaw = 160.0,
				objCoords = vector3(316.7887, -578.1945, 43.2841)
			}
		}
	},
	-- DUBBELE DEUR 5 (NAAR HET DAK)
	{
		textCoords = vector3(327.2453, -593.8099, 43.2841),
		authorizedJobs = { 'police', 'ambulance' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = 'gabz_pillbox_doubledoor_l',
				objYaw = 250.0,
				objCoords = vector3(327.5656, -593.0653, 43.2841)
			},
			{
				objName = 'gabz_pillbox_doubledoor_r',
				objYaw = 250.0,
				objCoords = vector3(327.012, -594.5692, 43.2841)
			}
		}
	},
	-- MRI
	{
		objName = 'gabz_pillbox_singledoor',
		objYaw = 340.0,
		objCoords  = vector3(336.5847, -580.932, 43.2841),
		textCoords = vector3(336.5847, -580.932, 43.2841),
		authorizedJobs = { 'police', 'ambulance' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
	},
	-- DIAGNOSTICS / STAFF ONLY
	{
		objName = 'gabz_pillbox_singledoor',
		objYaw = 340.0,
		objCoords  = vector3(341.3274, -582.6184, 43.2841),
		textCoords = vector3(341.3274, -582.6184, 43.2841),
		authorizedJobs = { 'police', 'ambulance' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
	},
	-- XRAY
	{
		objName = 'gabz_pillbox_singledoor',
		objYaw = 340.0,
		objCoords  = vector3(347.223, -584.766, 43.2841),
		textCoords = vector3(347.223, -584.766, 43.2841),
		authorizedJobs = { 'police', 'ambulance' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
	},
	-- DIRECTOR OFFICE
	{
		objName = 'gabz_pillbox_singledoor',
		objYaw = 340.0,
		objCoords  = vector3(337.5511, -592.2172, 43.2841),
		textCoords = vector3(337.5511, -592.2172, 43.2841),
		authorizedJobs = { 'police', 'ambulance' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
	},
	-- KANTINE
	{
		objName = 'gabz_pillbox_singledoor',
		objYaw = 160.0,
		objCoords  = vector3(308.7049, -597.1008, 43.2841),
		textCoords = vector3(308.7049, -597.1008, 43.2841),
		authorizedJobs = { 'police', 'ambulance' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
	},

	-- TESTING
	{
		objName = 'v_ilev_roc_door4',
		objYaw = 355.0,
		objCoords  = vector3(-564.4547, 276.5066, 83.1162),
		textCoords = vector3(-564.4547, 276.5066, 83.1162),
		authorizedJobs = { 'police', 'taquila' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},
	
	-- Bureau Sandy Shores - Voordeur
	{
		textCoords = vector3(1855.2, 3683.6, 34.6),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = 'v_ilev_shrfdoor',
				objCoords = vector3(1855.7, 3683.9, 34.5),
				objYaw = 30.0
			},
		}
	},
	-- Bureau Sandy Shores - Dubbele deuren links
	{
		textCoords = vector3(1850.5, 3683.0 ,34.4),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = 'v_ilev_rc_door2',
				objCoords = vector3(1851.2, 3681.8, 34.4),	
				objYaw = 120.0
			},
			{
				objName = 'v_ilev_rc_door2',
				objCoords = vector3(1849.9, 3684.1 ,34.4),		
				objYaw = -60.0
			},
		}
	},	
	-- Bureau Sandy Shores - Dubbele deuren centraal
	{
		textCoords = vector3(1848.45, 3690.3, 34.4),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = 'v_ilev_rc_door2',
				objCoords = vector3(1847.1, 3689.9, 34.4),			
				objYaw = 30.0									
			},
			{
				objName = 'v_ilev_rc_door2',
				objCoords = vector3(1849.4, 3691.2, 34.4),				
				objYaw = -152.0
			},
		}
	},
		-- Bureau Sandy Shores - Deur rechts
	{
		textCoords = vector3(1856.6, 3690.2, 34.4),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = 'v_ilev_rc_door2',
				objCoords = vector3(1857.2, 3690.2, 34.4),	
				objYaw = -150.0
			},
		}
	},
	-- Bureau Sandy Shores - Dubbele deuren beneden
	-- {
	-- 	textCoords = vector3(1847.5, 3683.4, 30.4),
	-- 	authorizedJobs = { 'police' },
	-- 	locking = false,
	-- 	locked = true,
	-- 	pickable = false,
	-- 	distance = 2.0,
	-- 	doors = {
	-- 		{
	-- 			objName = 'v_ilev_rc_door2',
	-- 			objCoords = vector3(1848.6, 3683.9, 30.4),			
	-- 			objYaw = 210.0									
	-- 		},
	-- 		{
	-- 			objName = 'v_ilev_rc_door2',
	-- 			objCoords = vector3(1846.4, 3682.6, 30.4),			
	-- 			objYaw = 30.0
	-- 		},
	-- 	}
	-- },	
	-- Bureau Sandy Shores - Dubbele deuren cellencomplex
	{
		textCoords = vector3(1850.2, 3682.7, 30.4),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		doors = {
			{
				objName = 'v_ilev_rc_door2',
				objCoords = vector3(1850.9, 3681.6, 30.4),			
				objYaw = 120.0									
			},
			{
				objName = 'v_ilev_rc_door2',
				objCoords = vector3(1849.6, 3683.8, 30.4),			
				objYaw = -60.0
			},
		}
	},		
	-- Bureau Sandy Shores - Verhoorkamer
	{
		textCoords = vector3(1852.2, 3686.4, 30.4),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = 'v_ilev_arm_secdoor',
				objCoords = vector3(1852.9, 3686.4, 30.4),	
				objYaw = 30.0
			},
		}
	},	
	-- Bureau Sandy Shores - Observatiekamer
	{
		textCoords = vector3(1855.5, 3688.2, 30.4),		
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = 'v_ilev_arm_secdoor',
				objCoords = vector3(1856.1, 3688.2, 30.4),	
				objYaw = 30.0
			},
		}
	},	
	-- Bureau Sandy Shores - Celdeur 1
	{
		textCoords = vector3(1859.3, 3687.2, 30.4),		
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.3,
		doors = {
			{
				objName = 'v_ilev_ph_cellgate1',
				objCoords = vector3(1859.6, 3686.644, 30.4),		
				objYaw = -60.0
			},
		}
	},	
	-- Bureau Sandy Shores - Celdeur 2
	{
		textCoords = vector3(1862.4, 3688.9, 30.4),		
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.3,
		doors = {
			{
				objName = 'v_ilev_ph_cellgate1',
				objCoords = vector3(1862.7, 3688.4, 30.4),			
				objYaw = -60.0
			},
		}
	},			
	-- Bureau Sandy Shores - Celdeur 3
	{
		textCoords = vector3(1860.5, 3692.1, 30.4),		
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.3,
		doors = {
			{
				objName = 'v_ilev_ph_cellgate1',
				objCoords = vector3(1860.8, 3691.6, 30.4),			
				objYaw = -60.0
			},
		}
	},		
	-- Bureau Sandy Shores - Celdeur 4
	{
		textCoords = vector3(1858.6, 3695.4, 30.4),		
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.3,
		doors = {
			{
				objName = 'v_ilev_ph_cellgate1',
				objCoords = vector3(1858.9, 3694.9, 30.4),				
				objYaw = -60.0
			},
		}
	},
	-- DUBBELE DEUR VANGELICO JUWELIER 
	{
		textCoords = vector3(-631.244, -237.405, 38.05),
		authorizedJobs = { 'police'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = 'p_jewel_door_l',
				objYaw = 305.0,
				objCoords = vector3(-631.850, -237.900, 38.500)
			},
			{
				objName = 'p_jewel_door_r1',
				objYaw = 307.0,
				objCoords = vector3(-630.850, -237.900, 38.500)
			}
		}
	},
}
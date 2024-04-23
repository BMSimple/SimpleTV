---------------------------------------
------ Шаблон для скрапера. 
------ Можно использовать как готовый скрапер, достаточно установить 3 параметра.
------ Можно использовать для написания своих скраперов для обработки сайтов.
------ Перед использованием устанавливаем настройки (3 пункта): 

------ 1. название модуля должно совпадать с названием этого файла ! (только без расширения ".lua")
module('template_pls', package.seeall)  

------ 2. здесь указываем путь к файлу (url или название файла xxxx.m3u в папке \TVSources\m3u\)       
local my_file_name = "playlist.m3u"     

------ 3. название источника
local my_src_name  = "Name1"             

------
------ после того как скрапер подготовлен, поместите его в папку \TVSources\AutoSetup\
------ источник занесется в TVSources вместе с настройками, которые возвращает фанкция GetSettings(). 
------ если снова поместить скрапер в \AutoSetup\ настройки не затираются (!) ,
------ т.к. занесение настоек происходит только в новый источник...
----------------------------------------

--------------------------------------------------------------------------
-- Локальный фильтр для переименования каналов. Заполнять не обязательно.
-- Если встретится первое название, то оно заменяется на второе
--------------------------------------------------------------------------
local filter={       
{"1 any channel","Какой-то 1 канал"},
{"2 any channel","Какой-то 2 канал"},
}
-------------------------------------------------------------------------
local function ProcessFilterTableLocal(t) -- применяем локальный фильтр
	if not type(t)=='table' then return end
	for _, v in pairs(t) do   
	    for _,ff in pairs(filter) do   
	      if (type(ff)=='table' and v.name==ff[1]) then 
	        v.name = ff[2]
	      end
	    end
	end 
    return t
end

--- Настройки ---------------------------------------------------------------
function GetSettings()

    local scrap_settings
	scrap_settings ={
	name	 		= my_src_name,   -- Имя источника                
	sortname 		='',			 -- префикс для сортировки               
	scraper 		='',		     -- * Путь и название скрапера (будет автоматически присвоено)     
	m3u     		='out_'.. (tvs_core and tvs_core.translit_UTF8(my_src_name) or '') ..'.m3u', --  название m3u         
	logo     		='..\\Channel\\logo\\Icons\\default.png', --  путь и файл лого относительно папки work 
	TypeSource		=1,				 -- * Тип источника: 0 - внутренний, 1 - внешний (будет автоматически присвоено 1)  
	TypeCoding		=1,				 -- Кодировка M3U (0 - ANSI, 1 - UTF8, 2 - UNICODE)         
	DeleteM3U		=1,				 -- Удалять временный m3u по завершению обработки (1 - включено, 0 - выключено)      
	RefreshButton   =1,				 -- Обновлять по круговой кнопке "Обновить плейлист" (1 - включено, 0 - выключено)    
	AutoBuild		=0,				 -- Автообновление (1 - включено, 0 - выключено)           
	AutoBuildDay	={0,0,0,0,0,0,0},-- Дни недели автообновления {вс,пн,вт,ср,чт,пт,сб}           
	LastStart		=0,				 -- Последняя успешная загрузка     
	show_progress	=0,              -- Показывать прогрессбар во время загрузки
	group_delim	    ='',	         -- Разделитель группы и названия ( например, двоеточие #EXTINF-1,group:name )
------------------------------------------------------------------------------------------------
	TVS				={				 -- Ветка настроек для загрузки в базу TVSources (1 - включено, 0 - выключено)   
		add			=1,				 -- Загружать в базу TVSources (1 - включено, 0 - выключено)           
		FilterCH	=1,				 -- Фильтровать названия каналов (1 - включено, 0 - выключено)          
		FilterGR	=1,				 -- Фильтровать названия групп каналов (1 - включено, 0 - выключено)     
		GetGroup	=1,				 -- Наследовать группу (1 - включено, 0 - выключено)     
		LogoTVG		=1},			 -- Наследовать логотип и программу передач (1 - включено, 0 - выключено)         
------------------------------------------------------------------------------------------------
	STV				={				 -- Ветка настроек для загрузки в базу SimpleTV            
		add			=1,				 -- Загружать в базу SimpleTV (1 - включено, 0 - выключено)         
		ExtFilter	=1,				 -- Создавать внешний фильтр (1 - включено, 0 - выключено)     
		FilterCH	=1,				 -- Фильтровать названия каналов (1 - включено, 0 - выключено)     
		FilterGR	=1,				 -- Фильтровать названия групп (1 - включено, 0 - выключено)          
		GetGroup	=1,				 -- Учитывать группы из M3U  (1 - включено, 0 - выключено)       
		HDGroup		=0,				 -- HD каналы отдельной группой  (1 - включено, 0 - выключено) 
		AutoSearch	=1,				  -- deprecated [Искать логотип и программу передач (1 - включено, 0 - выключено) ]
    AutoSearchEPG =1,       -- Искать программу передач
    AutoSearchLogo	=1,     -- Искать логотип
		UseLocalLogoOnly =0,	     -- использовать только локальные лого
		AutoNumber	=1,				 -- Автонумерация каналов (1 - включено, 0 - выключено)      
		NumberM3U	=0,				 -- Учитывать номера из M3U (1 - включено, 0 - выключено)       
		GetSettings	=1,				 -- Учитывать настройки из M3U (1 - включено, 0 - выключено)  
    UseUpdateID = 1,     -- генерировать Update-code
    SkipDuplicate	=1,   -- пропускать дубликаты,  если TypeSkip == 0  
		NotDeleteCH =0,				 -- Не удалять отсутствующие каналы при обновлении (1 - включено, 0 - выключено)     
		TypeSkip	=1,				 -- Если канал существует в базе: 0 - пропускать, 1 - обновлять, 2 - загружать как новый 
		TypeFind	=0}				 -- ^^^^^^^^^^^^^^^^^^^^ проверять совпадение по: 0 - названию канала, 1 - адресу канала

	}  
	                                                                                                                                        
	return scrap_settings
end
--------------------------------------------------------------------------
function GetVersion()
	return 1, 'UTF-8', 'test'
end
--------------------------------------------------------------------------

-------------------------------------------------------------------------- 
function GetList(UpdateID,m3u_file)

		 if UpdateID == nil then return end
		 if m3u_file == nil then return end
		 if TVSources_var.tmp.source[UpdateID] == nil then return end
		 local Source=TVSources_var.tmp.source[UpdateID]  

	tvs_core.tvs_debug("Scraper for "..Source.name.." begin.") 	
	m_simpleTV.OSD.ShowMessage_UTF8(Source.name..' -> ',0xffff00,5)


---------------- скачивание файла --------------------------

	local outm3u, err = tvs_func.get_m3u(my_file_name)	 
	if err~='' then tvs_core.tvs_ShowError(err)  m_simpleTV.Common.Wait(1000) end 
	if outm3u == nil or outm3u=='' then  return '' end
			
---------------- получаем таблицу  -----------------------------
    local t_pls = tvs_core.GetPlsAsTable(outm3u, UpdateID)    	
---------------------------------------------------------------
-- Возвращается t_pls с полями:
-- .name - название канала
-- .extfilter - тег ExtFilter
-- .group - тег group-title или #EXTGRP:
-- .logo - тег tvg-logo
-- .tvg - тег tvg-name
-- .deinterlace - тег deinterlace
-- .video_title - тег video-title, если есть video-title, то ищутся еще доп 3 тега:
--    .video_desc тег video-desc или video-desk
--    .video_cat тег video-cat
--    .video_len тег video-len
-- .group_logo тег group-logo
-- .group_logo_force тег group-logo-force
-- .group_is_unique тег group-is-unique
-- .address - строка с адресом канала
-- .skip - опция =false, установите далее дла нужных каналов true чтобы не загружать их
-- .RawM3UString - строка с тегами catchup, catchup-days или tvg-rec, catchup-minutes, 
--                 catchup-source, catchup-record-source
--
-- t_pls[1].extm3u - в первой строке таблицы дополнительно передается часть первой строки  
--                   после заголовка #EXTM3U
--
---------------- проходим локальным фильтром ------------------
    t_pls = ProcessFilterTableLocal(t_pls)
    
---------------- обрабатываем таблицу общими фильтрами  --------
-- в папке \core\ файлы channel_filter.lua, groups_filter.lua и channel_group.lua
-- далее генерируется итоговый m3u для загрузки через api программы.

    local m3ustr = tvs_core.ProcessFilterTable(UpdateID,Source,t_pls)   -- обязательно
	
	tvs_core.tvs_debug("Scraper for "..Source.name..": filtered 'm3u' info push into file ".. m3u_file)

	local handle = io.open (m3u_file, "w+")   -- m3u_file - не меняем название
	if handle == nil then return end
	handle:write (m3ustr)
	handle:close ()
	
	tvs_core.tvs_debug("Scraper for "..Source.name.." end: return 'ok'.")

	return 'ok'

end 


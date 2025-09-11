script_name("firedep_zam_helper")
script_version("Ver.11.09.A6")

local enable_autoupdate = true -- false to disable auto-update + disable sending initial telemetry (server, moonloader version, script version, samp nickname, virtual volume serial number)
local autoupdate_loaded = false
local Update = nil
local afk = false

local update_list = ('{00BFFF}1. {87CEFA}Добавлен список изменений в обновлении в сервисном меню.\n{00BFFF}2. {87CEFA}Скорректированы цвета.\n{00BFFF}3. {87CEFA}Добавлен режим АФК после рабочего дня.\n{00BFFF}4. {87CEFA}Добавлено автоматическое определение часового пояса.\n\n{FFD700}В перспективе следующего обновления:\n{00BFFF}1. {87CEFA}Внедрить хелпера пожарного департамента.\n{00BFFF}2. {87CEFA}Сделать автоматический ответ админам, если они спрашивают.\n{00BFFF}3. {87CEFA}Добавить пункт благодарность разработчику.')

local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=0x40E0D0;
                                                        sampAddChatMessage(b..'Обнаружено обновление. {FA8072}'..thisScript().version..' {40E0D0}на {7CFC00}'..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('Загружено %d из %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then 
                                                        sampShowDialog(0, "{FFA500}Вышло обновление", "{FFA500}Помощник руководителя пожарного департамента\n{78dbe2}был автоматически обновлен на новую версию.\nПосмотреть изменения можно в Меню -> Сервисные функции -> Изменения", "Закрыть", "", DIALOG_STYLE_MSGBOX)
                                                        print('Загрузка обновления завершена.')sampAddChatMessage(b..'Обновление завершено!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'Обновление прошло неудачно. Запускаю устаревшую версию..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': Обновление не требуется.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, выходим из ожидания проверки обновления. Смиритесь или проверьте самостоятельно на '..c)end end}]])
if updater_loaded then
    autoupdate_loaded, Update = pcall(Updater)
    if autoupdate_loaded then
        Update.json_url = "https://raw.githubusercontent.com/ArtemyevaIA/firedep_zam_helper/refs/heads/main/firedep_zam_helper.json?" .. tostring(os.clock())
        Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
        Update.url = "https://github.com/ArtemyevaIA/firedep_zam_helper"
    end

end

local mysql = require "luasql.mysql"
local env = assert(mysql.mysql())
local conn = assert(env:connect("arizona", "longames", "q2w3e4r5", "92.63.71.249", 3306))

local UTC = 4
local config = {}
local img = ''
local inspect = ''
local inspect_1, inspect_2, inspect_3, inspect_4, inspect_5 = '','','','',''
local docs = ''
local sobes = ',05,Пожарный департамент'
local start_sobes = false
local trstl1 = {['ph'] = 'ф',['Ph'] = 'Ф',['Ch'] = 'Ч',['ch'] = 'ч',['Th'] = 'Т',['th'] = 'т',['Sh'] = 'Ш',['sh'] = 'ш', ['ea'] = 'и',['Ae'] = 'Э',['ae'] = 'э',['size'] = 'сайз',['Jj'] = 'Джейджей',['Whi'] = 'Вай',['whi'] = 'вай',['Ck'] = 'К',['ck'] = 'к',['Kh'] = 'Х',['kh'] = 'х',['hn'] = 'н',['Hen'] = 'Ген',['Zh'] = 'Ж',['zh'] = 'ж',['Yu'] = 'Ю',['yu'] = 'ю',['Yo'] = 'Ё',['yo'] = 'ё',['Cz'] = 'Ц',['cz'] = 'ц', ['ia'] = 'я', ['ea'] = 'и',['Ya'] = 'Я', ['ya'] = 'я', ['ove'] = 'ав',['ay'] = 'эй', ['rise'] = 'райз',['oo'] = 'у', ['Oo'] = 'У'}
local trstl = {['B'] = 'Б',['Z'] = 'З',['T'] = 'Т',['Y'] = 'Й',['P'] = 'П',['J'] = 'Дж',['X'] = 'Кс',['G'] = 'Г',['V'] = 'В',['H'] = 'Х',['N'] = 'Н',['E'] = 'Е',['I'] = 'И',['D'] = 'Д',['O'] = 'О',['K'] = 'К',['F'] = 'Ф',['y`'] = 'ы',['e`'] = 'э',['A'] = 'А',['C'] = 'К',['L'] = 'Л',['M'] = 'М',['W'] = 'В',['Q'] = 'К',['U'] = 'А',['R'] = 'Р',['S'] = 'С',['zm'] = 'зьм',['h'] = 'х',['q'] = 'к',['y'] = 'и',['a'] = 'а',['w'] = 'в',['b'] = 'б',['v'] = 'в',['g'] = 'г',['d'] = 'д',['e'] = 'е',['z'] = 'з',['i'] = 'и',['j'] = 'ж',['k'] = 'к',['l'] = 'л',['m'] = 'м',['n'] = 'н',['o'] = 'о',['p'] = 'п',['r'] = 'р',['s'] = 'с',['t'] = 'т',['u'] = 'у',['f'] = 'ф',['x'] = 'x',['c'] = 'к',['``'] = 'ъ',['`'] = 'ь',['_'] = ' '}
local ffi                           = require('ffi')
local ImGui                         = require 'imgui'
local sampev                        = require "lib.samp.events"
local requests                      = require 'requests'
local encoding                      = require 'encoding'
encoding.default                    = 'CP1251'
local u8                            = encoding.UTF8
local bit                           = require('bit')
local date                          = os.date('%d.%m.%Y')
local spawnts                       = false
local vkey                          = require'vkeys'
local effil_check, effil            = pcall(require, 'effil')
ffi.cdef 'void __stdcall ExitProcess(unsigned int)'
require "lfs"
require "lib.moonloader"
math.randomseed(os.time())
local file = io.open("moonloader/firedep_zam_helper/list.json", "r")               -- Открываем файл в режиме чтения
        a = file:read("*a")                                             -- Читаем файл, там у нас таблица
        file:close()                                                    -- Закрываем
        info = decodeJson(a)                                            -- Читаем нашу JSON-Таблицу

-- require('samp.events').onShowDialog = function(dialogId, style, title, button1, button2, text)
--     text = ('ID: %d (%d) %s | %s'):format(dialogId,style,title, text)
--     return {dialogId, style, title, button1, button2, text}
-- end

function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then return end
    while not isSampAvailable() do wait(0) end
    
    if autoupdate_loaded and enable_autoupdate and Update then
        pcall(Update.check, Update.json_url, Update.prefix, Update.url)
    end
    UTC = getpoyas() - 3

    sampAddChatMessage('', 0x7FFFD4)
    sampAddChatMessage('{7FFFD4}Помощник руководителя пожарного департамента загружен', 0x7FFFD4)
    sampAddChatMessage('{7FFFD4}Версия помощника: {7CFC00}'..thisScript().version..' {7FFFD4}Часовой пояс: {FFFFFF}+ '..UTC..' {FFFFFF}мск', 0x7FFFD4)
    sampAddChatMessage('{7FFFD4}Команда для открытия меню {ffa000}/zam {7FFFD4}или клавиша {ffa000}Scroll Lock', 0x7FFFD4)
    sampAddChatMessage('{7FFFD4}Разработчик: {ffa000}Irin_Crown (Никита Артемьев)', 0x7FFFD4)
    sampAddChatMessage('', 0x7FFFD4)
    


    sampRegisterChatCommand('zam', zammenu)
    sampRegisterChatCommand('upd', upd)
    sampRegisterChatCommand('ps', test)
            
        while true do
        wait(0)

        if afk and os.date('%H:%M:%S', os.time() - (UTC * 3600)) == "19:55:00" then
            sampAddChatMessage("{90EE90}Время выходить из режима АФК",-1)
            wait(2000)
            sampProcessChatInput('/rec',-1)
        end

        if isKeyJustPressed(vkey.VK_SCROLL) then
           zammenu()
        end
        
        local result, button, list, input = sampHasDialogRespond(1999)
        if result then

            -----------------------------------------------------------------------------------
            -- Работа с составом --------------------------------------------------------------
            -----------------------------------------------------------------------------------

            if button == 1 and list == 0 then
                sostav()
                while sampIsDialogActive(2000) do wait(100) end
                local result, button, list, input = sampHasDialogRespond(2000)
                
                -----------------------------------------------------------------------------------
                -- Принять в организацию ----------------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 0 then
                    inputid()
                    while sampIsDialogActive(2001) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(2001)

                    if button == 1 then

                        local id = input
                        local nick = sampGetPlayerNickname(id)
                        local nm = trst(nick)

                        invitereason()
                        while sampIsDialogActive(2002) do wait(100) end
                        local result, button, list, input = sampHasDialogRespond(2002)
                        
                        -----------------------------------------------------------------------------------
                        -- [1] Вступление по собеседованию ------------------------------------------------
                        -----------------------------------------------------------------------------------
                        if button == 1 and list == 0 then
                            sampProcessChatInput('/do Сумка с формой на плече.',-1)
                            wait(1000)
                            sampProcessChatInput('/me положила сумку на пол и растегнула',-1)
                            wait(1000)
                            sampProcessChatInput('/do Сумка в открытом виде лежит на полу.',-1)
                            wait(1000)
                            sampProcessChatInput('/me взяла форму и передала человеку напротив',-1)
                            wait(1000)
                            sampProcessChatInput('/invite '..id,-1)
                            wait(1000)
                            sampProcessChatInput('/time ',-1)
                            wait(1000)

                            waitrp(id, nick)
                            while sampIsDialogActive(2004) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(2004)
                            if button == 1 then
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                                sampProcessChatInput('/fractionrp '..id,-1)
                                wait(2000)
                                sampProcessChatInput('/r Приветствуем нового сотрудника пожарного департамента - '..nm..'.',-1)
                                wait(2000)
                                sampProcessChatInput('/new '..id,-1)
                                sampProcessChatInput('/time ',-1)
                                sampShowDialog(0, "{FFA500}Новый член организации", "{78dbe2}Сотрудник: {ffa000}"..nick.." ["..id.."] {78dbe2}(по собеседованию)\n\nДата принятия: {ffa000}"..date.."\n{78dbe2}Время принятия: {ffa000}"..time.."{78dbe2}", "Док-ва", "Закрыть", DIALOG_STYLE_MSGBOX)

                                while sampIsDialogActive(0) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(0)
                                if button == 1 then
                                    inputdocs()
                                    while sampIsDialogActive(2021) do wait(100) end
                                    local result, button, _, input = sampHasDialogRespond(2021)

                                    if button == 1 then
                                        docsi = input
                                        docs = ('\nДок-ва: '..docsi)
                                    end
                                end
                                                                
                                lfs.mkdir('moonloader/firedep_zam_helper/Отчеты о проделанной работе/Принятие/'..date.. ' ' ..timed.. ' ' ..nick.. ' (invite)')
                                file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                                file:write('[Принятие в организацию по собеседованию]. Сотрудник: '..nick.. ' ['..id..'] Дата принятия: '..date..' Время принятия: '..time..'\n') --буфер откуда будет записывать инфу
                                file:close()

                                info = ('Принятие в организацию по собеседованию. \n\nСотрудник: '..nick.. ' ['..id..'] \nДата принятия: '..date..' \nВремя принятия: '..time..''..docs)
                                docs = ''
                                img = 'photo-232454643_456239037'
                                sendvkimg(encodeUrl(info),img)
                            end
                        end

                        -----------------------------------------------------------------------------------
                        -- [4] Вступление по заявлению на -------------------------------------------------
                        -----------------------------------------------------------------------------------
                        if button == 1 and list == 1 then
                            inputurl()
                            while sampIsDialogActive(2003) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(2003)

                            if button == 1 then
                                url = input
                                sampProcessChatInput('/do Сумка с формой на плече.',-1)
                                wait(1000)
                                sampProcessChatInput('/me положила сумку на пол и растегнула',-1)
                                wait(1000)
                                sampProcessChatInput('/do Сумка в открытом виде лежит на полу.',-1)
                                wait(1000)
                                sampProcessChatInput('/me взяла форму и передала человеку напротив',-1)
                                wait(1000)
                                sampProcessChatInput('/invite '..id,-1)
                                wait(1000)
                                sampProcessChatInput('/time ',-1)
                                wait(2000)
                                waitrp(id, nick)
                                while sampIsDialogActive(2004) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(2004)
                                if button == 1 then
                                    local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                    local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))
                                    sampProcessChatInput('/fractionrp '..id,-1)
                                    wait(2000)
                                    sampProcessChatInput('/r Приветствуем нового сотрудника пожарного департамента - '..nm..'.',-1)
                                    sampProcessChatInput('/new '..id,-1)
                                    wait(2000)
                                    sampProcessChatInput('/time ',-1)
                                    wait(2000)
                                    sampProcessChatInput('/do На поясе закреплен КПК.', -1)
                                    wait(1000)
                                    sampProcessChatInput('/me снимает КПК с пояса и нажатием кнопки включает его', -1)
                                    wait(1000)
                                    sampProcessChatInput('/me заходит в базу сотрудников и вводит изменения, после чего вешает КПК обратно на пояс', -1)
                                    wait(1000)
                                    sampProcessChatInput('/giverank '..id..' 4', -1)
                                    wait(1000)
                                    sampProcessChatInput('/r Сотрудник '..nm..' получил новую должность - Пожарный.', -1)
                                    wait(2000)
                                    sampProcessChatInput('/time', -1)
                                    wait(2000)
                                    sampShowDialog(0, "{FFA500}Новый член организации по заявлению.", "{78dbe2}Сотрудник: {ffa000}"..nick.." ["..id.."]\n{78dbe2}Новая должность: {ffa000}[4] Пожарный\n\n{78dbe2}Дата принятия: {ffa000}"..date.."\n{78dbe2}Время принятия: {ffa000}"..time.."\n\n{78dbe2}Ссылка на заявку: {ffa000}"..url, "Док-ва", "Закрыть", DIALOG_STYLE_MSGBOX)

                                    while sampIsDialogActive(0) do wait(100) end
                                    local result, button, _, input = sampHasDialogRespond(0)
                                    if button == 1 then
                                        inputdocs()
                                        while sampIsDialogActive(2021) do wait(100) end
                                        local result, button, _, input = sampHasDialogRespond(2021)

                                        if button == 1 then
                                            docsi = input
                                            docs = ('\nДок-ва: '..docsi)
                                        end
                                    end
                                                                        
                                    lfs.mkdir('moonloader/firedep_zam_helper/Отчеты о проделанной работе/Принятие/'..date.. ' ' ..timed.. ' ' ..nick.. ' (invite 4)')
                                    file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                                    file:write('[Принятие в организацию по заявке]. Сотрудник: '..nick.. ' ['..id..'] Новая должность: [4] Пожарный Дата принятия: '..date..' Время принятия: '..time..' Ссылка на заявку: '..url..'\n') --буфер откуда будет записывать инфу
                                    file:close()

                                    info = ('Принятие в организацию по заявлению. \n\nСотрудник: '..nick.. ' ['..id..'] \nДата принятия: '..date..' \nВремя принятия: '..time..''..docs)
                                    docs = ''
                                    
                                    img = 'photo-232454643_456239037'
                                    sendvkimg(encodeUrl(info),img)
                                    
                                end
                            end
                        end

                        -----------------------------------------------------------------------------------
                        -- [4] По собеседованию другим сотрудником ----------------------------------------
                        -----------------------------------------------------------------------------------
                        if button == 1 and list == 3 then
                            inputidorg()
                            while sampIsDialogActive(2016) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(2016)
                            if button == 1 then
                                local idorg = input
                                local nick_org = sampGetPlayerNickname(idorg)

                                sampProcessChatInput('/do Сумка с формой на плече.',-1)
                                wait(1000)
                                sampProcessChatInput('/me положила сумку на пол и растегнула',-1)
                                wait(1000)
                                sampProcessChatInput('/do Сумка в открытом виде лежит на полу.',-1)
                                wait(1000)
                                sampProcessChatInput('/me взяла форму и передала человеку напротив',-1)
                                wait(1000)
                                sampProcessChatInput('/invite '..id,-1)
                                wait(1000)
                                sampProcessChatInput('/time ',-1)
                                wait(1000)

                                waitrp(id, nick)
                                while sampIsDialogActive(2004) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(2004)
                                if button == 1 then
                                    local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                    local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                                    sampProcessChatInput('/r Приветствуем нового сотрудника пожарного департамента - '..nm..'.',-1)
                                    sampProcessChatInput('/new '..id,-1)
                                    wait(2000)
                                    sampProcessChatInput('/time ',-1)
                                    sampShowDialog(0, "{FFA500}Новый член организации", "{78dbe2}Сотрудник: {ffa000}"..nick.." ["..id.."] {78dbe2}(по собеседованию)\n{78dbe2}Проводил собеседование: {ffa000}"..nick_org.." ["..idorg.."]\n\n{78dbe2}Дата принятия: {ffa000}"..date.."\n{78dbe2}Время принятия: {ffa000}"..time.."{78dbe2}", "Док-ва", "Закрыть", DIALOG_STYLE_MSGBOX)
                                    
                                    while sampIsDialogActive(0) do wait(100) end
                                    local result, button, _, input = sampHasDialogRespond(0)
                                    if button == 1 then
                                        inputdocs()
                                        while sampIsDialogActive(2021) do wait(100) end
                                        local result, button, _, input = sampHasDialogRespond(2021)

                                        if button == 1 then
                                            docsi = input
                                            docs = ('\nДок-ва: '..docsi)
                                        end
                                    end

                                                                        
                                    lfs.mkdir('moonloader/firedep_zam_helper/Отчеты о проделанной работе/Принятие/'..date.. ' ' ..timed.. ' ' ..nick.. ' (invite)')
                                    file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                                    file:write('[Принятие в организацию по собеседованию]. Сотрудник: '..nick.. ' ['..id..'] Принял: '..nick_org..' ['..idorg..'] Дата принятия: '..date..' Время принятия: '..time..'\n') --буфер откуда будет записывать инфу
                                    file:close()

                                    info = ('Принятие в организацию по собеседованию. \n\nСотрудник: '..nick.. ' ['..id..'] \nДата принятия: '..date..' \nВремя принятия: '..time..'\nПроводил собеседвоание: '..nick_org..' ['..idorg..']'..docs)
                                    docs = ''

                                    img = 'photo-232454643_456239037'                                    
                                    sendvkimg(encodeUrl(info),img)
                                end
                            end
                        end
                    end
                end

                -----------------------------------------------------------------------------------
                -- Повысить сотрудника ------------------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 1 then
                    inputid()
                    while sampIsDialogActive(2001) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(2001)

                    if button == 1 then
                        local id = input
                        local nick = sampGetPlayerNickname(id)
                        local nm = trst(nick)

                        inputurl()
                        while sampIsDialogActive(2003) do wait(100) end
                        local result, button, _, input = sampHasDialogRespond(2003)

                        if button == 1 then
                            local url = input

                            ranklist()
                            while sampIsDialogActive(2007) do wait(100) end
                            local result, button, list, input = sampHasDialogRespond(2007)
                            local rank = {"Рекрут", "Старший рекрут", "Младший пожарный", "Пожарный", "Старший пожарный", "Пожарный инспектор", "Лейтенант", "Капитан"}
                            
                            -----------------------------------------------------------------------------------
                            -- [1] Рекрут ---------------------------------------------------------------------
                            -----------------------------------------------------------------------------------
                            if button == 1 and list == 0 then
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                                sampProcessChatInput('/do На поясе закреплен КПК.', -1)
                                wait(1000)
                                sampProcessChatInput('/me снимает КПК с пояса и нажатием кнопки включает его', -1)
                                wait(1000)
                                sampProcessChatInput('/me посмотрела очет по проделанной работе '..nm, -1)
                                wait(1000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampProcessChatInput('/checkjobprogress '..id, -1)
                                wait(2000)
                                sampProcessChatInput('/me заходит в базу сотрудников и вводит изменения, после чего вешает КПК обратно на пояс', -1)
                                wait(1000)
                                sampProcessChatInput('/giverank '..id..' '..(list+1), -1)
                                wait(1000)
                                sampProcessChatInput('/r Сотрудник '..nm..' получил новую должность - '..rank[list+1]..'.', -1)
                                wait(2000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampShowDialog(0, "{FFA500}Повышение сотрудника организации", "{78dbe2}Сотрудник: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}Дата повышения: {ffa000}"..date.."\n{78dbe2}Время повышения: {ffa000}"..time.."\n\n{78dbe2}Новая должность: {ffa000}["..(list+1).."] "..rank[list+1].."\n\n{78dbe2}Ссылка на отчет: {ffa000}"..url, "Закрыть", "", DIALOG_STYLE_MSGBOX)
                                
                                
                                lfs.mkdir('moonloader/firedep_zam_helper/Отчеты о проделанной работе/Повышения/'..date.. ' ' ..timed.. ' ' ..nick.. ' (giverank+)')
                                file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                                file:write('[Повышение в должности]. Сотрудник: '..nick.. ' ['..id..'] Дата повышения: '..date..' Время повышения: '..time..' Новая должность: ['..(list+1)..'] '..rank[list+1]..' Ссылка на отчет: '..url..'\n') --буфер откуда будет записывать инфу
                                file:close()

                                info = ('Повышение в должности. \n\nСотрудник: '..nick.. ' ['..id..'] \nДата повышения: '..date..' \nВремя повышения: '..time..' \nНовая должность: ['..(list+1)..'] '..rank[list+1]..' \nСсылка на отчет: '..url)
                                
                                img = 'photo-232454643_456239038'
                                sendvkimg(encodeUrl(info),img)
                            end
                            
                            -----------------------------------------------------------------------------------
                            -- [2] Старший рекрут -------------------------------------------------------------
                            -----------------------------------------------------------------------------------
                            if button == 1 and list == 1 then
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                                sampProcessChatInput('/do На поясе закреплен КПК.', -1)
                                wait(1000)
                                sampProcessChatInput('/me снимает КПК с пояса и нажатием кнопки включает его', -1)
                                wait(1000)
                                sampProcessChatInput('/me посмотрела очет по проделанной работе '..nm, -1)
                                wait(1000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampProcessChatInput('/checkjobprogress '..id, -1)
                                wait(2000)
                                sampProcessChatInput('/me заходит в базу сотрудников и вводит изменения, после чего вешает КПК обратно на пояс', -1)
                                wait(1000)
                                sampProcessChatInput('/giverank '..id..' '..(list+1), -1)
                                wait(1000)
                                sampProcessChatInput('/r Сотрудник '..nm..' получил новую должность - '..rank[list+1]..'.', -1)
                                wait(2000)
                                sampProcessChatInput('/time', -1)
                                sampShowDialog(0, "{FFA500}Повышение сотрудника организации", "{78dbe2}Сотрудник: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}Дата повышения: {ffa000}"..date.."\n{78dbe2}Время повышения: {ffa000}"..time.."\n\n{78dbe2}Новая должность: {ffa000}["..(list+1).."] "..rank[list+1].."\n\n{78dbe2}Ссылка на отчет: {ffa000}"..url, "Закрыть", "", DIALOG_STYLE_MSGBOX)
                                
                                                                lfs.mkdir('moonloader/firedep_zam_helper/Отчеты о проделанной работе/Повышения/'..date.. ' ' ..timed.. ' ' ..nick.. ' (giverank+)')
                                file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                                file:write('[Повышение в должности]. Сотрудник: '..nick.. ' ['..id..'] Дата повышения: '..date..' Время повышения: '..time..' Новая должность: ['..(list+1)..'] '..rank[list+1]..' Ссылка на отчет: '..url..'\n') --буфер откуда будет записывать инфу
                                file:close()

                                info = ('Повышение в должности. \n\nСотрудник: '..nick.. ' ['..id..'] \nДата повышения: '..date..' \nВремя повышения: '..time..' \nНовая должность: ['..(list+1)..'] '..rank[list+1]..' \nСсылка на отчет: '..url)
                                
                                img = 'photo-232454643_456239038'
                                sendvkimg(encodeUrl(info),img)
                            end
                            
                            -----------------------------------------------------------------------------------
                            -- [3] Младший пожарный -----------------------------------------------------------
                            -----------------------------------------------------------------------------------
                            if button == 1 and list == 2 then
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                                sampProcessChatInput('/do На поясе закреплен КПК.', -1)
                                wait(1000)
                                sampProcessChatInput('/me снимает КПК с пояса и нажатием кнопки включает его', -1)
                                wait(1000)
                                sampProcessChatInput('/me посмотрела очет по проделанной работе '..nm, -1)
                                wait(1000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampProcessChatInput('/checkjobprogress '..id, -1)
                                wait(2000)
                                sampProcessChatInput('/me заходит в базу сотрудников и вводит изменения, после чего вешает КПК обратно на пояс', -1)
                                wait(1000)
                                sampProcessChatInput('/giverank '..id..' '..(list+1), -1)
                                wait(1000)
                                sampProcessChatInput('/r Сотрудник '..nm..' получил новую должность - '..rank[list+1]..'.', -1)
                                wait(2000)
                                sampProcessChatInput('/time', -1)
                                sampShowDialog(0, "{FFA500}Повышение сотрудника организации", "{78dbe2}Сотрудник: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}Дата повышения: {ffa000}"..date.."\n{78dbe2}Время повышения: {ffa000}"..time.."\n\n{78dbe2}Новая должность: {ffa000}["..(list+1).."] "..rank[list+1].."\n\n{78dbe2}Ссылка на отчет: {ffa000}"..url, "Закрыть", "", DIALOG_STYLE_MSGBOX)
                                
                                
                                lfs.mkdir('moonloader/firedep_zam_helper/Отчеты о проделанной работе/Повышения/'..date.. ' ' ..timed.. ' ' ..nick.. ' (giverank+)')
                                file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                                file:write('[Повышение в должности]. Сотрудник: '..nick.. ' ['..id..'] Дата повышения: '..date..' Время повышения: '..time..' Новая должность: ['..(list+1)..'] '..rank[list+1]..' Ссылка на отчет: '..url..'\n') --буфер откуда будет записывать инфу
                                file:close()

                                info = ('Повышение в должности. \n\nСотрудник: '..nick.. ' ['..id..'] \nДата повышения: '..date..' \nВремя повышения: '..time..' \nНовая должность: ['..(list+1)..'] '..rank[list+1]..' \nСсылка на отчет: '..url)
                                
                                img = 'photo-232454643_456239038'
                                sendvkimg(encodeUrl(info),img)
                            end
                            
                            -----------------------------------------------------------------------------------
                            -- [4] Пожарный -------------------------------------------------------------------
                            -----------------------------------------------------------------------------------
                            if button == 1 and list == 3 then
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                                sampProcessChatInput('/do На поясе закреплен КПК.', -1)
                                wait(1000)
                                sampProcessChatInput('/me снимает КПК с пояса и нажатием кнопки включает его', -1)
                                wait(1000)
                                sampProcessChatInput('/me посмотрела очет по проделанной работе '..nm, -1)
                                wait(1000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampProcessChatInput('/checkjobprogress '..id, -1)
                                wait(2000)
                                sampProcessChatInput('/me заходит в базу сотрудников и вводит изменения, после чего вешает КПК обратно на пояс', -1)
                                wait(1000)
                                sampProcessChatInput('/giverank '..id..' '..(list+1), -1)
                                wait(1000)
                                sampProcessChatInput('/r Сотрудник '..nm..' получил новую должность - '..rank[list+1]..'.', -1)
                                wait(2000)
                                sampProcessChatInput('/time', -1)
                                sampShowDialog(0, "{FFA500}Повышение сотрудника организации", "{78dbe2}Сотрудник: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}Дата повышения: {ffa000}"..date.."\n{78dbe2}Время повышения: {ffa000}"..time.."\n\n{78dbe2}Новая должность: {ffa000}["..(list+1).."] "..rank[list+1].."\n\n{78dbe2}Ссылка на отчет: {ffa000}"..url, "Закрыть", "", DIALOG_STYLE_MSGBOX)
                                
                                
                                lfs.mkdir('moonloader/firedep_zam_helper/Отчеты о проделанной работе/Повышения/'..date.. ' ' ..timed.. ' ' ..nick.. ' (giverank+)')
                                file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                                file:write('[Повышение в должности]. Сотрудник: '..nick.. ' ['..id..'] Дата повышения: '..date..' Время повышения: '..time..' Новая должность: ['..(list+1)..'] '..rank[list+1]..' Ссылка на отчет: '..url..'\n') --буфер откуда будет записывать инфу
                                file:close()

                                info = ('Повышение в должности. \n\nСотрудник: '..nick.. ' ['..id..'] \nДата повышения: '..date..' \nВремя повышения: '..time..' \nНовая должность: ['..(list+1)..'] '..rank[list+1]..' \nСсылка на отчет: '..url)
                                
                                img = 'photo-232454643_456239038'
                                sendvkimg(encodeUrl(info),img)
                            end
                            
                            -----------------------------------------------------------------------------------
                            -- [5] Старший пожарный -----------------------------------------------------------
                            -----------------------------------------------------------------------------------
                            if button == 1 and list == 4 then
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                                sampProcessChatInput('/do На поясе закреплен КПК.', -1)
                                wait(1000)
                                sampProcessChatInput('/me снимает КПК с пояса и нажатием кнопки включает его', -1)
                                wait(1000)
                                sampProcessChatInput('/me посмотрела очет по проделанной работе '..nm, -1)
                                wait(1000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampProcessChatInput('/checkjobprogress '..id, -1)
                                wait(2000)
                                sampProcessChatInput('/me заходит в базу сотрудников и вводит изменения, после чего вешает КПК обратно на пояс', -1)
                                wait(1000)
                                sampProcessChatInput('/giverank '..id..' '..(list+1), -1)
                                wait(1000)
                                sampProcessChatInput('/r Сотрудник '..nm..' получил новую должность - '..rank[list+1]..'.', -1)
                                wait(2000)
                                sampProcessChatInput('/time', -1)
                                sampShowDialog(0, "{FFA500}Повышение сотрудника организации", "{78dbe2}Сотрудник: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}Дата повышения: {ffa000}"..date.."\n{78dbe2}Время повышения: {ffa000}"..time.."\n\n{78dbe2}Новая должность: {ffa000}["..(list+1).."] "..rank[list+1].."\n\n{78dbe2}Ссылка на отчет: {ffa000}"..url, "Закрыть", "", DIALOG_STYLE_MSGBOX)
                                
                                
                                lfs.mkdir('moonloader/firedep_zam_helper/Отчеты о проделанной работе/Повышения/'..date.. ' ' ..timed.. ' ' ..nick.. ' (giverank+)')
                                file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                                file:write('[Повышение в должности]. Сотрудник: '..nick.. ' ['..id..'] Дата повышения: '..date..' Время повышения: '..time..' Новая должность: ['..(list+1)..'] '..rank[list+1]..' Ссылка на отчет: '..url..'\n') --буфер откуда будет записывать инфу
                                file:close()

                                info = ('Повышение в должности. \n\nСотрудник: '..nick.. ' ['..id..'] \nДата повышения: '..date..' \nВремя повышения: '..time..' \nНовая должность: ['..(list+1)..'] '..rank[list+1]..' \nСсылка на отчет: '..url)
                                
                                img = 'photo-232454643_456239038'
                                sendvkimg(encodeUrl(info),img)
                            end
                            
                            -----------------------------------------------------------------------------------
                            -- [6] Пожарный иинспектор --------------------------------------------------------
                            -----------------------------------------------------------------------------------
                            if button == 1 and list == 5 then
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                                sampProcessChatInput('/do На поясе закреплен КПК.', -1)
                                wait(1000)
                                sampProcessChatInput('/me снимает КПК с пояса и нажатием кнопки включает его', -1)
                                wait(1000)
                                sampProcessChatInput('/me посмотрела очет по проделанной работе '..nm, -1)
                                wait(1000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampProcessChatInput('/checkjobprogress '..id, -1)
                                wait(2000)
                                sampProcessChatInput('/me заходит в базу сотрудников и вводит изменения, после чего вешает КПК обратно на пояс', -1)
                                wait(1000)
                                sampProcessChatInput('/giverank '..id..' '..(list+1), -1)
                                wait(1000)
                                sampProcessChatInput('/r Сотрудник '..nm..' получил новую должность - '..rank[list+1]..'.', -1)
                                wait(2000)
                                sampProcessChatInput('/time', -1)
                                sampShowDialog(0, "{FFA500}Повышение сотрудника организации", "{78dbe2}Сотрудник: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}Дата повышения: {ffa000}"..date.."\n{78dbe2}Время повышения: {ffa000}"..time.."\n\n{78dbe2}Новая должность: {ffa000}["..(list+1).."] "..rank[list+1].."\n\n{78dbe2}Ссылка на отчет: {ffa000}"..url, "Закрыть", "", DIALOG_STYLE_MSGBOX)
                                
                                
                                lfs.mkdir('moonloader/firedep_zam_helper/Отчеты о проделанной работе/Повышения/'..date.. ' ' ..timed.. ' ' ..nick.. ' (giverank+)')
                                file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                                file:write('[Повышение в должности]. Сотрудник: '..nick.. ' ['..id..'] Дата повышения: '..date..' Время повышения: '..time..' Новая должность: ['..(list+1)..'] '..rank[list+1]..' Ссылка на отчет: '..url..'\n') --буфер откуда будет записывать инфу
                                file:close()

                                info = ('Повышение в должности. \n\nСотрудник: '..nick.. ' ['..id..'] \nДата повышения: '..date..' \nВремя повышения: '..time..' \nНовая должность: ['..(list+1)..'] '..rank[list+1]..' \nСсылка на отчет: '..url)
                                
                                img = 'photo-232454643_456239038'
                                sendvkimg(encodeUrl(info),img)
                            end
                            
                            -----------------------------------------------------------------------------------
                            -- [7] Лейтенант ------------------------------------------------------------------
                            -----------------------------------------------------------------------------------
                            if button == 1 and list == 6 then
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                                sampProcessChatInput('/do На поясе закреплен КПК.', -1)
                                wait(1000)
                                sampProcessChatInput('/me снимает КПК с пояса и нажатием кнопки включает его', -1)
                                wait(1000)
                                sampProcessChatInput('/me посмотрела очет по проделанной работе '..nm, -1)
                                wait(1000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampProcessChatInput('/checkjobprogress '..id, -1)
                                wait(2000)
                                sampProcessChatInput('/me заходит в базу сотрудников и вводит изменения, после чего вешает КПК обратно на пояс', -1)
                                wait(1000)
                                sampProcessChatInput('/giverank '..id..' '..(list+1), -1)
                                wait(1000)
                                sampProcessChatInput('/r Сотрудник '..nm..' получил новую должность - '..rank[list+1]..'.', -1)
                                wait(2000)
                                sampProcessChatInput('/time', -1)
                                sampShowDialog(0, "{FFA500}Повышение сотрудника организации", "{78dbe2}Сотрудник: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}Дата повышения: {ffa000}"..date.."\n{78dbe2}Время повышения: {ffa000}"..time.."\n\n{78dbe2}Новая должность: {ffa000}["..(list+1).."] "..rank[list+1].."\n\n{78dbe2}Ссылка на отчет: {ffa000}"..url, "Закрыть", "", DIALOG_STYLE_MSGBOX)
                                
                                
                                lfs.mkdir('moonloader/firedep_zam_helper/Отчеты о проделанной работе/Повышения/'..date.. ' ' ..timed.. ' ' ..nick.. ' (giverank+)')
                                file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                                file:write('[Повышение в должности]. Сотрудник: '..nick.. ' ['..id..'] Дата повышения: '..date..' Время повышения: '..time..' Новая должность: ['..(list+1)..'] '..rank[list+1]..' Ссылка на отчет: '..url..'\n') --буфер откуда будет записывать инфу
                                file:close()

                                info = ('Повышение в должности. \n\nСотрудник: '..nick.. ' ['..id..'] \nДата повышения: '..date..' \nВремя повышения: '..time..' \nНовая должность: ['..(list+1)..'] '..rank[list+1]..' \nСсылка на отчет: '..url)
                                
                                img = 'photo-232454643_456239038'
                                sendvkimg(encodeUrl(info),img)
                            end
                            
                            -----------------------------------------------------------------------------------
                            -- [8] Капитан --------------------------------------------------------------------
                            -----------------------------------------------------------------------------------
                            if button == 1 and list == 7 then
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                                sampProcessChatInput('/do На поясе закреплен КПК.', -1)
                                wait(1000)
                                sampProcessChatInput('/me снимает КПК с пояса и нажатием кнопки включает его', -1)
                                wait(1000)
                                sampProcessChatInput('/me посмотрела очет по проделанной работе '..nm, -1)
                                wait(1000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampProcessChatInput('/checkjobprogress '..id, -1)
                                wait(2000)
                                sampProcessChatInput('/me заходит в базу сотрудников и вводит изменения, после чего вешает КПК обратно на пояс', -1)
                                wait(1000)
                                sampProcessChatInput('/giverank '..id..' '..(list+1), -1)
                                wait(1000)
                                sampProcessChatInput('/r Сотрудник '..nm..' получил новую должность - '..rank[list+1]..'.', -1)
                                wait(2000)
                                sampProcessChatInput('/time', -1)
                                sampShowDialog(0, "{FFA500}Повышение сотрудника организации", "{78dbe2}Сотрудник: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}Дата повышения: {ffa000}"..date.."\n{78dbe2}Время повышения: {ffa000}"..time.."\n\n{78dbe2}Новая должность: {ffa000}["..(list+1).."] "..rank[list+1].."\n\n{78dbe2}Ссылка на отчет: {ffa000}"..url, "Закрыть", "", DIALOG_STYLE_MSGBOX)
                                
                                
                                lfs.mkdir('moonloader/firedep_zam_helper/Отчеты о проделанной работе/Повышения/'..date.. ' ' ..timed.. ' ' ..nick.. ' (giverank+)')
                                file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                                file:write('[Повышение в должности]. Сотрудник: '..nick.. ' ['..id..'] Дата повышения: '..date..' Время повышения: '..time..' Новая должность: ['..(list+1)..'] '..rank[list+1]..' Ссылка на отчет: '..url..'\n') --буфер откуда будет записывать инфу
                                file:close()

                                info = ('Повышение в должности. \n\nСотрудник: '..nick.. ' ['..id..'] \nДата повышения: '..date..' \nВремя повышения: '..time..' \nНовая должность: ['..(list+1)..'] '..rank[list+1]..' \nСсылка на отчет: '..url)
                                
                                img = 'photo-232454643_456239038'
                                sendvkimg(encodeUrl(info),img)
                            end
                        end
                    end
                end

                -----------------------------------------------------------------------------------
                -- Снять выговор ------------------------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 2 then
                    inputid()
                    while sampIsDialogActive(2000) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(2000)
                    
                    if button == 1 then
                    
                        local id = input
                        local nick = sampGetPlayerNickname(id)
                        local nm = trst(nick)

                        inputreason()
                        while sampIsDialogActive(2005) do wait(100) end
                        local result, button, _, input = sampHasDialogRespond(2005)
                        if button == 1 then
                            local reason = input
                            local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                            local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                            sampProcessChatInput('/do КПК весит на поясе.',-1)
                            wait(1000)
                            sampProcessChatInput('/me снял КПК с пояса и включил его',-1)
                            wait(1000)
                            sampProcessChatInput('/do КПК включен.',-1)
                            wait(1000)
                            sampProcessChatInput('/me зашла в базу данных сотрудников',-1)
                            wait(1000)
                            sampProcessChatInput('/me нашла нужного сотрудника и изменила личное дело',-1)
                            wait(1000)
                            sampProcessChatInput('/me посмотрела очет по проделанной работе '..nm, -1)
                            wait(1000)
                            sampProcessChatInput('/time', -1)
                            wait(2000)
                            sampProcessChatInput('/checkjobprogress '..id, -1)
                            wait(2000)
                            sampProcessChatInput('/unfwarn '..id,-1)
                            wait(1000)
                            sampProcessChatInput('/me выключила КПК и повесила на пояс',-1)
                            wait(1000)
                            sampProcessChatInput('/do КПК весит на поясе.',-1)
                            wait(1000)
                            sampProcessChatInput('/r Сотруднику '..nm..' было снято дисциплинарное взыскание. Принина - '..reason,-1)
                            wait(2000)
                            sampProcessChatInput('/time ',-1)
                            wait(2000)
                            sampShowDialog(0, "{FFA500}Сняие сотруднику организации", "{78dbe2}Сотрудник: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}Дата снятия выговора: {ffa000}"..date.."\n{78dbe2}Время снятия выговора: {ffa000}"..time.."\n\n{78dbe2}Причина снятия выговора: {ffa000}"..reason, "Закрыть", "", DIALOG_STYLE_MSGBOX)

                            while sampIsDialogActive(0) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(0)
                            if button == 1 then
                                inputdocs()
                                while sampIsDialogActive(2021) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(2021)

                                if button == 1 then
                                    docsi = input
                                    docs = ('\nДок-ва: '..docsi)
                                end
                            end

                            
                            lfs.mkdir('moonloader/firedep_zam_helper/Отчеты о проделанной работе/Снятие наказаний/'..date.. ' ' ..timed.. ' ' ..nick.. ' (unfwarn)')
                            file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                            file:write('[Снятие выговора]. Сотрудник: '..nick.. ' ['..id..'] Дата снятия: '..date..' Время снятия: '..time..' Причина: '..reason..'\n') --буфер откуда будет записывать инфу
                            file:close()

                            info = ('Снятие выговора. \n\nСотрудник: '..nick.. ' ['..id..'] \nДата снятия: '..date..' \nВремя снятия: '..time..' \nПричина: '..reason..''..docs)
                            docs = ''
                            img = 'photo-232454643_456239041'
                            sendvkimg(encodeUrl(info),img)
                        end
                    end
                end

                -----------------------------------------------------------------------------------
                -- Выдать выговор -----------------------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 3 then
                    inputid()
                    while sampIsDialogActive(2001) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(2001)
                    
                    if button == 1 then 
                    
                        local id = input
                        local nick = sampGetPlayerNickname(id)
                        local nm = trst(nick)
                        
                        reason_fwarn()
                        while sampIsDialogActive(2013) do wait(100) end
                        local result, button, list, input = sampHasDialogRespond(2013)
                        if button == 1 and list == 0 then                                                               -- Нарушение устава                    
                            local reason = "Н.У."
                            local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                            local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                            sampProcessChatInput('/do КПК весит на поясе.',-1)
                            wait(1000)
                            sampProcessChatInput('/me сняла КПК с пояса и включила его',-1)
                            wait(1000)
                            sampProcessChatInput('/do КПК включен.',-1)
                            wait(1000)
                            sampProcessChatInput('/me зашла в базу данных сотрудников',-1)
                            wait(1000)
                            sampProcessChatInput('/me нашла нужного сотрудника и изменила личное дело',-1)
                            wait(1000)
                            sampProcessChatInput('/me посмотрела очет по проделанной работе '..nm, -1)
                            wait(1000)
                            sampProcessChatInput('/time', -1)
                            wait(2000)
                            sampProcessChatInput('/checkjobprogress '..id, -1)
                            wait(2000)
                            sampProcessChatInput('/fwarn '..id..' '..reason,-1)
                            wait(1000)
                            sampProcessChatInput('/me выключила КПК и повесила на пояс',-1)
                            wait(1000)
                            sampProcessChatInput('/do КПК весит.',-1)
                            wait(2000)
                            sampProcessChatInput('/r Сотрудник '..nm..' получил дисциплинарное взыскание по причине - '..reason..'.',-1)
                            wait(2000)
                            sampProcessChatInput('/time ',-1)
                            wait(2000)
                            sampShowDialog(0, "{FFA500}Выговор сотруднику организации", "{78dbe2}Сотрудник: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}Дата выговора: {ffa000}"..date.."\n{78dbe2}Время выговора: {ffa000}"..time.."\n\n{78dbe2}Причина выговора: {ffa000}"..reason, "Док-ва", "Закрыть", DIALOG_STYLE_MSGBOX)
                            
                            while sampIsDialogActive(0) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(0)
                            if button == 1 then
                                inputdocs()
                                while sampIsDialogActive(2021) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(2021)

                                if button == 1 then
                                    docsi = input
                                    docs = ('\nДок-ва: '..docsi)
                                end
                            end

                                                        
                            lfs.mkdir('moonloader/firedep_zam_helper/Отчеты о проделанной работе/Наказания/'..date.. ' ' ..timed.. ' ' ..nick.. ' (fwarn)')
                            file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                            file:write('[Выдача выговора]. Сотрудник: '..nick.. ' ['..id..'] Дата выговора: '..date..' Время выговора: '..time..' Причина: '..reason..'\n') --буфер откуда будет записывать инфу
                            file:close()
                            
                            info = ('Выдача выговора. \n\nСотрудник: '..nick.. ' ['..id..'] \nДата выговора: '..date..' \nВремя выговора: '..time..' \nПричина: '..reason..''..docs)
                            docs = ''
                            img = 'photo-232454643_456239035'
                            sendvkimg(encodeUrl(info),img)
                        end

                        if button == 1 and list == 1 then                                                               -- Прогул рабочего дня
                            local reason = "Прогул РД"
                            local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                            local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                            sampProcessChatInput('/do КПК весит на поясе.',-1)
                            wait(1000)
                            sampProcessChatInput('/me сняла КПК с пояса и включила его',-1)
                            wait(1000)
                            sampProcessChatInput('/do КПК включен.',-1)
                            wait(1000)
                            sampProcessChatInput('/me зашла в базу данных сотрудников',-1)
                            wait(1000)
                            sampProcessChatInput('/me нашла нужного сотрудника и изменила личное дело',-1)
                            wait(1000)
                            sampProcessChatInput('/me посмотрела очет по проделанной работе '..nm, -1)
                            wait(1000)
                            sampProcessChatInput('/time', -1)
                            wait(2000)
                            sampProcessChatInput('/checkjobprogress '..id, -1)
                            wait(2000)
                            sampProcessChatInput('/fwarn '..id..' '..reason,-1)
                            wait(1000)
                            sampProcessChatInput('/me выключила КПК и повесила на пояс',-1)
                            wait(1000)
                            sampProcessChatInput('/do КПК весит.',-1)
                            wait(2000)
                            sampProcessChatInput('/r Сотрудник '..nm..' получил дисциплинарное взыскание по причине - '..reason..'.',-1)
                            wait(2000)
                            sampProcessChatInput('/time ',-1)
                            wait(2000)
                            sampShowDialog(0, "{FFA500}Выговор сотруднику организации", "{78dbe2}Сотрудник: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}Дата выговора: {ffa000}"..date.."\n{78dbe2}Время выговора: {ffa000}"..time.."\n\n{78dbe2}Причина выговора: {ffa000}"..reason, "Док-ва", "Закрыть", DIALOG_STYLE_MSGBOX)

                            while sampIsDialogActive(0) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(0)
                            if button == 1 then
                                inputdocs()
                                while sampIsDialogActive(2021) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(2021)

                                if button == 1 then
                                    docsi = input
                                    docs = ('\nДок-ва: '..docsi)
                                end
                            end

                                                        
                            lfs.mkdir('moonloader/firedep_zam_helper/Отчеты о проделанной работе/Наказания/'..date.. ' ' ..timed.. ' ' ..nick.. ' (fwarn)')
                            file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                            file:write('[Выдача выговора]. Сотрудник: '..nick.. ' ['..id..'] Дата выговора: '..date..' Время выговора: '..time..' Причина: '..reason..'\n') --буфер откуда будет записывать инфу
                            file:close()

                            info = ('Выдача выговора. \n\nСотрудник: '..nick.. ' ['..id..'] \nДата выговора: '..date..' \nВремя выговора: '..time..' \nПричина: '..reason..''..docs)
                            docs = ''
                            img = 'photo-232454643_456239035'
                            sendvkimg(encodeUrl(info),img)
                            
                        end

                        if button == 1 and list == 2 then                                                               -- Сон на посту
                            local reason = "Сон на посту"
                            local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                            local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                            sampProcessChatInput('/do КПК весит на поясе.',-1)
                            wait(1000)
                            sampProcessChatInput('/me сняла КПК с пояса и включила его',-1)
                            wait(1000)
                            sampProcessChatInput('/do КПК включен.',-1)
                            wait(1000)
                            sampProcessChatInput('/me зашла в базу данных сотрудников',-1)
                            wait(1000)
                            sampProcessChatInput('/me нашла нужного сотрудника и изменила личное дело',-1)
                            wait(1000)
                            sampProcessChatInput('/me посмотрела очет по проделанной работе '..nm, -1)
                            wait(1000)
                            sampProcessChatInput('/time', -1)
                            wait(2000)
                            sampProcessChatInput('/checkjobprogress '..id, -1)
                            wait(2000)
                            sampProcessChatInput('/fwarn '..id..' '..reason,-1)
                            wait(1000)
                            sampProcessChatInput('/me выключила КПК и повесила на пояс',-1)
                            wait(1000)
                            sampProcessChatInput('/do КПК весит.',-1)
                            wait(2000)
                            sampProcessChatInput('/r Сотрудник '..nm..' получил дисциплинарное взыскание по причине - '..reason..'.',-1)
                            wait(2000)
                            sampProcessChatInput('/time ',-1)
                            wait(2000)

                            sampShowDialog(0, "{FFA500}Выговор сотруднику организации", "{78dbe2}Сотрудник: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}Дата выговора: {ffa000}"..date.."\n{78dbe2}Время выговора: {ffa000}"..time.."\n\n{78dbe2}Причина выговора: {ffa000}"..reason, "Док-ва", "Закрыть", DIALOG_STYLE_MSGBOX)

                            while sampIsDialogActive(0) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(0)
                            if button == 1 then
                                inputdocs()
                                while sampIsDialogActive(2021) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(2021)

                                if button == 1 then
                                    docsi = input
                                    docs = ('\nДок-ва: '..docsi)
                                end
                            end

                                                        
                            lfs.mkdir('moonloader/firedep_zam_helper/Отчеты о проделанной работе/Наказания/'..date.. ' ' ..timed.. ' ' ..nick.. ' (fwarn)')
                            file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                            file:write('[Выдача выговора]. Сотрудник: '..nick.. ' ['..id..'] Дата выговора: '..date..' Время выговора: '..time..' Причина: '..reason..'\n') --буфер откуда будет записывать инфу
                            file:close()

                            info = ('Выдача выговора. \n\nСотрудник: '..nick.. ' ['..id..'] \nДата выговора: '..date..' \nВремя выговора: '..time..' \nПричина: '..reason..''..docs)
                            docs = ''
                            img = 'photo-232454643_456239035'
                            sendvkimg(encodeUrl(info),img)
                            
                        end

                        if button == 1 and list == 3 then                                                               -- Отсутствие активности
                            local reason = "Неактив"
                            local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                            local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                            sampProcessChatInput('/do КПК весит на поясе.',-1)
                            wait(1000)
                            sampProcessChatInput('/me сняла КПК с пояса и включила его',-1)
                            wait(1000)
                            sampProcessChatInput('/do КПК включен.',-1)
                            wait(1000)
                            sampProcessChatInput('/me зашла в базу данных сотрудников',-1)
                            wait(1000)
                            sampProcessChatInput('/me нашла нужного сотрудника и изменила личное дело',-1)
                            wait(1000)
                            sampProcessChatInput('/me посмотрела очет по проделанной работе '..nm, -1)
                            wait(1000)
                            sampProcessChatInput('/time', -1)
                            wait(2000)
                            sampProcessChatInput('/checkjobprogress '..id, -1)
                            wait(2000)
                            sampProcessChatInput('/fwarn '..id..' '..reason,-1)
                            wait(1000)
                            sampProcessChatInput('/me выключила КПК и повесила на пояс',-1)
                            wait(1000)
                            sampProcessChatInput('/do КПК весит.',-1)
                            wait(2000)
                            sampProcessChatInput('/r Сотрудник '..nm..' получил дисциплинарное взыскание по причине - '..reason..'.',-1)
                            wait(2000)
                            sampProcessChatInput('/time ',-1)
                            wait(2000)
                            sampShowDialog(0, "{FFA500}Выговор сотруднику организации", "{78dbe2}Сотрудник: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}Дата выговора: {ffa000}"..date.."\n{78dbe2}Время выговора: {ffa000}"..time.."\n\n{78dbe2}Причина выговора: {ffa000}"..reason, "Док-ва", "Закрыть", DIALOG_STYLE_MSGBOX)
                            
                            while sampIsDialogActive(0) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(0)
                            if button == 1 then
                                inputdocs()
                                while sampIsDialogActive(2021) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(2021)

                                if button == 1 then
                                    docsi = input
                                    docs = ('\nДок-ва: '..docsi)
                                end
                            end

                                                        
                            lfs.mkdir('moonloader/firedep_zam_helper/Отчеты о проделанной работе/Наказания/'..date.. ' ' ..timed.. ' ' ..nick.. ' (fwarn)')
                            file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                            file:write('[Выдача выговора]. Сотрудник: '..nick.. ' ['..id..'] Дата выговора: '..date..' Время выговора: '..time..' Причина: '..reason..'\n') --буфер откуда будет записывать инфу
                            file:close()

                            info = ('Выдача выговора. \n\nСотрудник: '..nick.. ' ['..id..'] \nДата выговора: '..date..' \nВремя выговора: '..time..' \nПричина: '..reason..''..docs)
                            docs = ''
                            img = 'photo-232454643_456239035'
                            sendvkimg(encodeUrl(info),img)
                            
                        end

                        if button == 1 and list == 5 then

                            inputreason()
                            while sampIsDialogActive(2005) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(2005)
                            if button == 1 then
                                local reason = input
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                                sampProcessChatInput('/do КПК весит на поясе.',-1)
                                wait(1000)
                                sampProcessChatInput('/me сняла КПК с пояса и включила его',-1)
                                wait(1000)
                                sampProcessChatInput('/do КПК включен.',-1)
                                wait(1000)
                                sampProcessChatInput('/me зашла в базу данных сотрудников',-1)
                                wait(1000)
                                sampProcessChatInput('/me нашла нужного сотрудника и изменила личное дело',-1)
                                wait(1000)
                                sampProcessChatInput('/me посмотрела очет по проделанной работе '..nm, -1)
                                wait(1000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampProcessChatInput('/checkjobprogress '..id, -1)
                                wait(2000)
                                sampProcessChatInput('/fwarn '..id..' '..reason,-1)
                                wait(1000)
                                sampProcessChatInput('/me выключила КПК и повесила на пояс',-1)
                                wait(1000)
                                sampProcessChatInput('/do КПК весит.',-1)
                                wait(2000)
                                sampProcessChatInput('/r Сотрудник '..nm..' получил дисциплинарное взыскание по причине - '..reason..'.',-1)
                                wait(2000)
                                sampProcessChatInput('/time ',-1)
                                wait(2000)
                                sampShowDialog(0, "{FFA500}Выговор сотруднику организации", "{78dbe2}Сотрудник: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}Дата выговора: {ffa000}"..date.."\n{78dbe2}Время выговора: {ffa000}"..time.."\n\n{78dbe2}Причина выговора: {ffa000}"..reason, "Док-ва", "Закрыть", DIALOG_STYLE_MSGBOX)
                                
                                while sampIsDialogActive(0) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(0)
                                if button == 1 then
                                    inputdocs()
                                    while sampIsDialogActive(2021) do wait(100) end
                                    local result, button, _, input = sampHasDialogRespond(2021)

                                    if button == 1 then
                                        docsi = input
                                        docs = ('\nДок-ва: '..docsi)
                                    end
                                end
                                                                
                                lfs.mkdir('moonloader/firedep_zam_helper/Отчеты о проделанной работе/Наказания/'..date.. ' ' ..timed.. ' ' ..nick.. ' (fwarn)')
                                file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                                file:write('[Выдача выговора]. Сотрудник: '..nick.. ' ['..id..'] Дата выговора: '..date..' Время выговора: '..time..' Причина: '..reason..'\n') --буфер откуда будет записывать инфу
                                file:close()

                                info = ('Выдача выговора. \n\nСотрудник: '..nick.. ' ['..id..'] \nДата выговора: '..date..' \nВремя выговора: '..time..' \nПричина: '..reason..''..docs)
                                docs = ''
                                img = 'photo-232454643_456239035'
                                sendvkimg(encodeUrl(info),img)
                            end
                        end
                    end
                end

                -----------------------------------------------------------------------------------
                -- Выдать выговор (офлайн) --------------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 4 then
                    inputnick()
                    while sampIsDialogActive(2008) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(2008)
                    
                    if button == 1 then
                    
                        local nick = input
                        local nm = trst(nick)
                        
                        inputreason()
                        while sampIsDialogActive(2005) do wait(100) end
                        local result, button, _, input = sampHasDialogRespond(2005)
                        if button == 1 then
                            local reason = input
                            local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                            local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                            sampProcessChatInput('/do КПК весит на поясе.',-1)
                            wait(1000)
                            sampProcessChatInput('/me сняла КПК с пояса и включила его',-1)
                            wait(1000)
                            sampProcessChatInput('/do КПК включен.',-1)
                            wait(1000)
                            sampProcessChatInput('/me зашла в базу данных сотрудников',-1)
                            wait(1000)
                            sampProcessChatInput('/me нашла нужного сотрудника и изменила личное дело',-1)
                            wait(1000)
                            sampProcessChatInput('/me посмотрела очет по проделанной работе '..nm, -1)
                            wait(1000)
                            sampProcessChatInput('/fwarnoff '..nick..' '..reason,-1)
                            wait(1000)
                            sampProcessChatInput('/me выключила КПК и повесила на пояс',-1)
                            wait(1000)
                            sampProcessChatInput('/do КПК весит.',-1)
                            wait(2000)
                            sampProcessChatInput('/r Сотрудник '..nm..' получил дисциплинарное взыскание по причине - '..reason..'.',-1)
                            wait(2000)
                            sampProcessChatInput('/time ',-1)
                            sampShowDialog(0, "{FFA500}Выговор сотруднику организации", "{78dbe2}Сотрудник: {ffa000}"..nick.." (офлайн)\n\n{78dbe2}Дата выговора: {ffa000}"..date.."\n{78dbe2}Время выговора: {ffa000}"..time.."\n\n{78dbe2}Причина выговора: {ffa000}"..reason, "Док-ва", "Закрыть", DIALOG_STYLE_MSGBOX)

                            while sampIsDialogActive(0) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(0)
                            if button == 1 then
                                inputdocs()
                                while sampIsDialogActive(2021) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(2021)

                                if button == 1 then
                                    docsi = input
                                    docs = ('\nДок-ва: '..docsi)
                                end
                            end
                            
                            lfs.mkdir('moonloader/firedep_zam_helper/Отчеты о проделанной работе/Наказания/'..date.. ' ' ..timed.. ' ' ..nick.. ' (fwarnoff)')
                            file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                            file:write('[Выдача выговора офлайн]. Сотрудник: '..nick.. ' (офлайн) Дата принятия: '..date..' Время принятия: '..time..' Причина: '..reason..'\n') --буфер откуда будет записывать инфу
                            file:close()

                            info = ('Выдача выговора офлайн. \n\nСотрудник: '..nick.. ' (офлайн) \nДата выговора: '..date..' \nВремя выговора: '..time..' \nПричина: '..reason..''..docs)
                            docs = ''
                            img = 'photo-232454643_456239035'
                            sendvkimg(encodeUrl(info),img)
                            
                        end
                    end
                end

                -----------------------------------------------------------------------------------
                -- Уволить из оганизации ----------------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 5 then
                    inputid()
                    while sampIsDialogActive(2001) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(2001)
                    
                    if button == 1 then
                    
                        local id = input
                        local nick = sampGetPlayerNickname(id)
                        local nm = trst(nick)
                        
                        inputreason()
                        while sampIsDialogActive(2005) do wait(100) end
                        local result, button, _, input = sampHasDialogRespond(2005)
                        if button == 1 then
                            local reason = input
                            local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                            local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                            sampProcessChatInput('/do КПК весит на поясе.', -1)
                            wait(1000)
                            sampProcessChatInput('/me сняла КПК с пояса и включила его', -1)
                            wait(1000)
                            sampProcessChatInput('/do КПК включен.', -1)
                            wait(1000)
                            sampProcessChatInput('/me зашла в базу данных сотрудников', -1)
                            wait(1000)
                            sampProcessChatInput('/me нашла нужного сотрудника и удалила из базы данных', -1)
                            wait(1000)
                            sampProcessChatInput('/me посмотрела очет по проделанной работе '..nm, -1)
                            wait(1000)
                            sampProcessChatInput('/time', -1)
                            wait(2000)
                            sampProcessChatInput('/checkjobprogress '..id, -1)
                            wait(2000)
                            sampProcessChatInput('/me выключила КПК и повесила на пояс', -1)
                            wait(1000)
                            sampProcessChatInput('/do КПК весит на поясе.', -1)
                            wait(1000)
                            sampProcessChatInput('/me заблокировала канал радиостанции сотруднику '..nm, -1)
                            wait(1000)
                            sampProcessChatInput('/uninvite '..id..' '..reason, -1)
                            wait(1000)
                            sampProcessChatInput('/r Сотрудник '..nm..' был уволен из организации по причине: '..reason..'.',-1)
                            wait(2000)
                            sampProcessChatInput('/time ',-1)
                            sampShowDialog(0, "{FFA500}Увольнение сотрудника из организации", "{78dbe2}Сотрудник: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}Дата увольнения: {ffa000}"..date.."\n{78dbe2}Время увольнения: {ffa000}"..time.."\n\n{78dbe2}Причина увольнения: {ffa000}"..reason, "Док-ва", "Закрыть", DIALOG_STYLE_MSGBOX)
                            
                            while sampIsDialogActive(0) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(0)
                            if button == 1 then
                                inputdocs()
                                while sampIsDialogActive(2021) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(2021)

                                if button == 1 then
                                    docsi = input
                                    docs = ('\nДок-ва: '..docsi)
                                end
                            end

                                                        
                            lfs.mkdir('moonloader/firedep_zam_helper/Отчеты о проделанной работе/Наказания/'..date.. ' ' ..timed.. ' ' ..nick.. ' (uninvite)')
                            file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                            file:write('[Увольнение сотрудника из организации]. Сотрудник: '..nick.. ' ['..id..'] Дата увольнения: '..date..' Время увольнения: '..time..' Причина: '..reason..'\n') --буфер откуда будет записывать инфу
                            file:close()

                            info = ('Увольнение сотрудника из организации. \n\nСотрудник: '..nick.. ' ['..id..'] \nДата увольнения: '..date..' \nВремя увольнения: '..time..' \nПричина: '..reason..''..docs)
                            docs = ''
                            img = 'photo-232454643_456239045'
                            sendvkimg(encodeUrl(info),img)
                            
                        end
                    end
                end

                -----------------------------------------------------------------------------------
                -- Уволить из оганизации (офлайн) -------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 6 then
                    inputnick()
                    while sampIsDialogActive(2008) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(2008)
                    
                    if button == 1 then
                    
                        local nick = input
                        local nm = trst(nick)
                        
                        inputreason()
                        while sampIsDialogActive(2005) do wait(100) end
                        local result, button, _, input = sampHasDialogRespond(2005)
                        if button == 1 then
                            local reason = input
                            local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                            local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                            sampProcessChatInput('/do КПК весит на поясе.', -1)
                            wait(1000)
                            sampProcessChatInput('/me сняла КПК с пояса и включила его', -1)
                            wait(1000)
                            sampProcessChatInput('/do КПК включен.', -1)
                            wait(1000)
                            sampProcessChatInput('/me зашла в базу данных сотрудников', -1)
                            wait(1000)
                            sampProcessChatInput('/me нашла нужного сотрудника и удалила из базы данных', -1)
                            wait(1000)
                            sampProcessChatInput('/me выключила КПК и повесила на пояс', -1)
                            wait(1000)
                            sampProcessChatInput('/do КПК весит на поясе.', -1)
                            wait(1000)
                            sampProcessChatInput('/me заблокировала канал радиостанции сотруднику '..nm, -1)
                            wait(1000)
                            sampProcessChatInput('/uninviteoff '..nick, -1)
                            wait(7000)
                            sampProcessChatInput('/r Сотрудник '..nm..' был уволен из организации по причине: '..reason..'.',-1)
                            wait(2000)
                            sampProcessChatInput('/time ',-1)
                            sampShowDialog(0, "{FFA500}Увольнение сотрудника из организации", "{78dbe2}Сотрудник: {ffa000}"..nick.." (офлайн)\n\n{78dbe2}Дата увольнения: {ffa000}"..date.."\n{78dbe2}Время увольнения: {ffa000}"..time.."\n\n{78dbe2}Причина увольнения: {ffa000}"..reason, "Док-ва", "Закрыть", DIALOG_STYLE_MSGBOX)
                            
                            while sampIsDialogActive(0) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(0)
                            if button == 1 then
                                inputdocs()
                                while sampIsDialogActive(2021) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(2021)

                                if button == 1 then
                                    docsi = input
                                    docs = ('\nДок-ва: '..docsi)
                                end
                            end
                                                        
                            lfs.mkdir('moonloader/firedep_zam_helper/Отчеты о проделанной работе/Наказания/'..date.. ' ' ..timed.. ' ' ..nick.. ' (uninviteoff)')
                            file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                            file:write('[Увольнение сотрудника из организации офлайн]. Сотрудник: '..nick.. ' (офлайн) Дата увольнения: '..date..' Время увольнения: '..time..' Причина: '..reason..'\n') --буфер откуда будет записывать инфу
                            file:close()

                            info = ('Увольнение сотрудника из организации офлайн. \n\nСотрудник: '..nick.. ' (офлайн) \nДата увольнения: '..date..' \nВремя увольнения: '..time..' \nПричина: '..reason..''..docs)
                            docs = ''
                            img = 'photo-232454643_456239045'
                            sendvkimg(encodeUrl(info),img)
                            
                        end
                    end
                end

                -----------------------------------------------------------------------------------
                -- Выдать заглушку чата -----------------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 7 then
                    inputid()
                    while sampIsDialogActive(2001) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(2001)
                    
                    if button == 1 then
                    
                        local id = input
                        local nick = sampGetPlayerNickname(id)
                        local nm = trst(nick)
                        
                        reason_mute()
                        while sampIsDialogActive(2012) do wait(100) end
                        local result, button, list, input = sampHasDialogRespond(2012)
                        
                        if button == 1 and list == 0 then                                           -- Принича: Села батарейка в рации
                            local reason = 'Села батарейка в рации'
                            local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                            local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                            sampProcessChatInput('/do Рация весит на поясе.', -1)
                            wait(1000)
                            sampProcessChatInput('/me сняла рацию с пояса, вошла в черный список часточного диапазона', -1)
                            wait(1000)
                            sampProcessChatInput('/me заблокировала частоту '..id, -1)
                            wait(1000)
                            sampProcessChatInput('/me повесила рацию на пояс', -1)
                            wait(1000)
                            sampProcessChatInput('/do Рация весит на поясе.', -1)
                            wait(1000)
                            sampProcessChatInput('/fmute '..id..' 15 '..reason, -1)
                            wait(1000)
                            sampProcessChatInput('/r Сотруднику '..nm..' был заблокирован канал рации на 15 минут по причине: '..reason..'.',-1)
                            wait(2000)
                            sampProcessChatInput('/time ',-1)
                            sampShowDialog(0, "{FFA500}Блокировка радиочастоты", "{78dbe2}Сотрудник: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}Дата блокировки: {ffa000}"..date.."\n{78dbe2}Время блокировки: {ffa000}"..time.."\n\n{78dbe2}Причина блокировки: {ffa000}"..reason, "Док-ва", "Закрыть", DIALOG_STYLE_MSGBOX)

                            while sampIsDialogActive(0) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(0)
                            if button == 1 then
                                inputdocs()
                                while sampIsDialogActive(2021) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(2021)

                                if button == 1 then
                                    docsi = input
                                    docs = ('\nДок-ва: '..docsi)
                                end
                            end

                            
                            lfs.mkdir('moonloader/firedep_zam_helper/Отчеты о проделанной работе/Наказания/'..date.. ' ' ..timed.. ' ' ..nick.. ' (fmute)')
                            file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                            file:write('[Блокировка канала радиостанции]. Сотрудник: '..nick.. ' ['..id..'] Дата блокировки: '..date..' Время блокировки: '..time..' Причина: '..reason..'\n') --буфер откуда будет записывать инфу
                            file:close()

                            info = ('Блокировка канала радиостанции. \n\nСотрудник: '..nick.. ' ['..id..'] \nДата блокировки: '..date..' \nВремя блокировки: '..time..' \nПричина: '..reason..''..docs)
                            docs = ''
                            img = 'photo-232454643_456239036'
                            sendvkimg(encodeUrl(info),img)
                            
                        end

                        if button == 1 and list == 1 then                                           -- Принича: Оскорбление коллег
                            local reason = 'Оскорбление коллег'
                            local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                            local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                            sampProcessChatInput('/do Рация весит на поясе.', -1)
                            wait(1000)
                            sampProcessChatInput('/me сняла рацию с пояса, вошла в черный список часточного диапазона', -1)
                            wait(1000)
                            sampProcessChatInput('/me заблокировала частоту '..id, -1)
                            wait(1000)
                            sampProcessChatInput('/me повесила рацию на пояс', -1)
                            wait(1000)
                            sampProcessChatInput('/do Рация весит на поясе.', -1)
                            wait(1000)
                            sampProcessChatInput('/fmute '..id..' 10 '..reason, -1)
                            wait(1000)
                            sampProcessChatInput('/r Сотруднику '..nm..' был заблокирован канал рации на 10 минут по причине: '..reason..'.',-1)
                            wait(2000)
                            sampProcessChatInput('/time ',-1)
                            sampShowDialog(0, "{FFA500}Блокировка радиочастоты", "{78dbe2}Сотрудник: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}Дата блокировки: {ffa000}"..date.."\n{78dbe2}Время блокировки: {ffa000}"..time.."\n\n{78dbe2}Причина блокировки: {ffa000}"..reason, "Док-ва", "Закрыть", DIALOG_STYLE_MSGBOX)

                            while sampIsDialogActive(0) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(0)
                            if button == 1 then
                                inputdocs()
                                while sampIsDialogActive(2021) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(2021)

                                if button == 1 then
                                    docsi = input
                                    docs = ('\nДок-ва: '..docsi)
                                end
                            end

                            
                            lfs.mkdir('moonloader/firedep_zam_helper/Отчеты о проделанной работе/Наказания/'..date.. ' ' ..timed.. ' ' ..nick.. ' (fmute)')
                            file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                            file:write('[Блокировка канала радиостанции]. Сотрудник: '..nick.. ' ['..id..'] Дата блокировки: '..date..' Время блокировки: '..time..' Причина: '..reason..'\n') --буфер откуда будет записывать инфу
                            file:close()

                            info = ('Блокировка канала радиостанции. \n\nСотрудник: '..nick.. ' ['..id..'] \nДата блокировки: '..date..' \nВремя блокировки: '..time..' \nПричина: '..reason..''..docs)
                            docs = ''
                            img = 'photo-232454643_456239036'
                            sendvkimg(encodeUrl(info),img)
                            
                        end

                        if button == 1 and list == 3 then                                           -- Принича: Ввести вручную
                            inputreason()
                            while sampIsDialogActive(2005) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(2005)
                            if button == 1 then
                                local reason = input
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                                sampProcessChatInput('/do Рация весит на поясе.', -1)
                                wait(1000)
                                sampProcessChatInput('/me сняла рацию с пояса, вошла в черный список часточного диапазона', -1)
                                wait(1000)
                                sampProcessChatInput('/me заблокировала частоту '..id, -1)
                                wait(1000)
                                sampProcessChatInput('/me повесила рацию на пояс', -1)
                                wait(1000)
                                sampProcessChatInput('/do Рация весит на поясе.', -1)
                                wait(1000)
                                sampProcessChatInput('/fmute '..id..' 10 '..reason, -1)
                                wait(1000)
                                sampProcessChatInput('/r Сотруднику '..nm..' был заблокирован канал рации на 10 минут по причине: '..reason..'.',-1)
                                wait(2000)
                                sampProcessChatInput('/time ',-1)
                                sampShowDialog(0, "{FFA500}Блокировка радиочастоты", "{78dbe2}Сотрудник: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}Дата блокировки: {ffa000}"..date.."\n{78dbe2}Время блокировки: {ffa000}"..time.."\n\n{78dbe2}Причина блокировки: {ffa000}"..reason, "Док-ва", "Закрыть", DIALOG_STYLE_MSGBOX)

                                while sampIsDialogActive(0) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(0)
                                if button == 1 then
                                    inputdocs()
                                    while sampIsDialogActive(2021) do wait(100) end
                                    local result, button, _, input = sampHasDialogRespond(2021)

                                    if button == 1 then
                                        docsi = input
                                        docs = ('\nДок-ва: '..docsi)
                                    end
                                end

                                
                                lfs.mkdir('moonloader/firedep_zam_helper/Отчеты о проделанной работе/Наказания/'..date.. ' ' ..timed.. ' ' ..nick.. ' (fmute)')
                                file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                                file:write('[Блокировка канала радиостанции]. Сотрудник: '..nick.. ' ['..id..'] Дата блокировки: '..date..' Время блокировки: '..time..' Причина: '..reason..'\n') --буфер откуда будет записывать инфу
                                file:close()

                                info = ('Блокировка канала радиостанции. \n\nСотрудник: '..nick.. ' ['..id..'] \nДата блокировки: '..date..' \nВремя блокировки: '..time..' \nПричина: '..reason..''..docs)
                                docs = ''
                                img = 'photo-232454643_456239036'
                                sendvkimg(encodeUrl(info),img)
                                
                            end
                        end
                    end
                end

                -----------------------------------------------------------------------------------
                -- Внести в черный список ---------------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 8 then
                    inputid()
                    while sampIsDialogActive(2001) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(2001)
                    
                    if button == 1 then
                    
                        local id = input
                        local nick = sampGetPlayerNickname(id)
                        local nm = trst(nick)
                        
                        inputreason()
                        while sampIsDialogActive(2005) do wait(100) end
                        local result, button, _, input = sampHasDialogRespond(2005)
                        if button == 1 then
                            local reason = input
                            local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                            local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                            sampProcessChatInput('/do На поясе закреплен КПК.', -1)
                            wait(1000)
                            sampProcessChatInput('/me снимает КПК с пояса и нажатием кнопки включает его', -1)
                            wait(1000)
                            sampProcessChatInput('/me заходит в базу данных организации, и выбирает пункт *Чёрный список*', -1)
                            wait(1000)
                            sampProcessChatInput('/me переходя в новую вкладку, в выбранном поле вписывает Имя и Фамилию человека', -1)
                            wait(1000)
                            sampProcessChatInput('/me нажимает на кнопку *Внести*', -1)
                            wait(1000)
                            sampProcessChatInput('/me выключает КПК и вешает обратно на пояс', -1)
                            wait(2000)
                            sampProcessChatInput('/blacklist '..id.. ' -1 '..reason, -1)
                            wait(1000)
                            sampProcessChatInput('/r Сотрудник '..nm..' был занесен в черный список организации по причине - '..reason..'.',-1)
                            wait(2000)
                            sampProcessChatInput('/time ',-1)
                            sampShowDialog(0, "{FFA500}Занесение в ЧС ОРГ", "{78dbe2}Сотрудник: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}Дата занесения: {ffa000}"..date.."\n{78dbe2}Время Занесения: {ffa000}"..time.."\n\n{78dbe2}Причина блокировки: {ffa000}"..reason, "Док-ва", "Закрыть", DIALOG_STYLE_MSGBOX)

                            while sampIsDialogActive(0) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(0)
                            if button == 1 then
                                inputdocs()
                                while sampIsDialogActive(2021) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(2021)

                                if button == 1 then
                                    docsi = input
                                    docs = ('\nДок-ва: '..docsi)
                                end
                            end

                            
                            lfs.mkdir('moonloader/firedep_zam_helper/Отчеты о проделанной работе/Наказания/'..date.. ' ' ..timed.. ' ' ..nick.. ' (blacklist)')
                            file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                            file:write('[Занесение в ЧС орг]. Сотрудник: '..nick.. ' ['..id..'] Дата занесения: '..date..' Время занесения: '..time..' Причина: '..reason..'\n') --буфер откуда будет записывать инфу
                            file:close()

                            info = ('Занесение в ЧС орг. \n\nСотрудник: '..nick.. ' ['..id..'] \nДата занесения: '..date..' \nВремя занесения: '..time..' \nПричина: '..reason..''..docs)
                            docs = ''
                            img = 'photo-232454643_456239046'
                            sendvkimg(encodeUrl(info),img)
                            
                        end
                    end
                end

                -----------------------------------------------------------------------------------
                -- Внести в черный список (офлайн) ------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 9 then
                    inputnick()
                    while sampIsDialogActive(2008) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(2008)
                    
                    if button == 1 then
                    
                        local nick = input
                        local nm = trst(nick)
                        
                        inputreason()
                        while sampIsDialogActive(2005) do wait(100) end
                        local result, button, _, input = sampHasDialogRespond(2005)
                        if button == 1 then
                            local reason = input
                            local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                            local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                            sampProcessChatInput('/do На поясе закреплен КПК.', -1)
                            wait(1000)
                            sampProcessChatInput('/me снимает КПК с пояса и нажатием кнопки включает его', -1)
                            wait(1000)
                            sampProcessChatInput('/me заходит в базу данных организации, и выбирает пункт *Чёрный список*', -1)
                            wait(1000)
                            sampProcessChatInput('/me переходя в новую вкладку, в выбранном поле вписывает Имя и Фамилию человека', -1)
                            wait(1000)
                            sampProcessChatInput('/me нажимает на кнопку *Внести*', -1)
                            wait(1000)
                            sampProcessChatInput('/me выключает КПК и вешает обратно на пояс', -1)
                            wait(2000)
                            sampProcessChatInput('/blacklistoff '..nick.. ' -1 '..reason, -1)
                            wait(1000)
                            sampProcessChatInput('/r Сотрудник '..nm..' был занесен в черный список организации по причине - '..reason..'.',-1)
                            wait(2000)
                            sampProcessChatInput('/time ',-1)
                            sampShowDialog(0, "{FFA500}Занесение в ЧС ОРГ", "{78dbe2}Сотрудник: {ffa000}"..nick.." (офлайн)\n\n{78dbe2}Дата занесения: {ffa000}"..date.."\n{78dbe2}Время Занесения: {ffa000}"..time.."\n\n{78dbe2}Причина блокировки: {ffa000}"..reason, "Док-ва", "Закрыть", DIALOG_STYLE_MSGBOX)

                            while sampIsDialogActive(0) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(0)
                            if button == 1 then
                                inputdocs()
                                while sampIsDialogActive(2021) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(2021)

                                if button == 1 then
                                    docsi = input
                                    docs = ('\nДок-ва: '..docsi)
                                end
                            end

                            
                            lfs.mkdir('moonloader/firedep_zam_helper/Отчеты о проделанной работе/Наказания/'..date.. ' ' ..timed.. ' ' ..nick.. ' (blacklistoff)')
                            file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                            file:write('[Занесение в ЧС орг]. Сотрудник: '..nick.. ' (офлайн) Дата занесения: '..date..' Время занесения: '..time..' Причина: '..reason..'\n') --буфер откуда будет записывать инфу
                            file:close()

                            info = ('Занесение в ЧС орг. офлайн \n\nСотрудник: '..nick.. ' (офлайн) \nДата занесения: '..date..' \nВремя занесения: '..time..' \nПричина: '..reason..''..docs)
                            docs = ''
                            img = 'photo-232454643_456239046'
                            sendvkimg(encodeUrl(info),img)
                            
                        end
                    end
                end

                -----------------------------------------------------------------------------------
                -- Понизить сотрудника ------------------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 10 then
                    inputid()

                    while sampIsDialogActive(2001) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(2001)

                    if button == 1 then
                        local id = input
                        local nick = sampGetPlayerNickname(id)
                        local nm = trst(nick)

                        inputreason()
                        while sampIsDialogActive(2005) do wait(100) end
                        local result, button, _, input = sampHasDialogRespond(2005)
                        
                        if button == 1 then
                            ranklist()
                            while sampIsDialogActive(2007) do wait(100) end
                            local reason = input
                            local result, button, list, input = sampHasDialogRespond(2007)
                            local rank = {"Рекрут", "Старший рекрут", "Младший пожарный", "Пожарный", "Старший пожарный", "Пожарный инспектор", "Лейтенант", "Капитан"}

                            if button == 1 and list == 0 then
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                                sampProcessChatInput('/do На поясе закреплен КПК.', -1)
                                wait(1000)
                                sampProcessChatInput('/me снимает КПК с пояса и нажатием кнопки включает его', -1)
                                wait(1000)
                                sampProcessChatInput('/me посмотрела очет по проделанной работе '..nm, -1)
                                wait(1000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampProcessChatInput('/checkjobprogress '..id, -1)
                                wait(2000)
                                sampProcessChatInput('/me заходит в базу сотрудников и вводит изменения, после чего вешает КПК обратно на пояс', -1)
                                wait(1000)
                                sampProcessChatInput('/giverank '..id..' '..(list+1), -1)
                                wait(1000)
                                sampProcessChatInput('/r Сотрудник '..nm..' был понижен в должности до '..rank[list+1]..' по причине - '..reason, -1)
                                wait(2000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampShowDialog(0, "{FFA500}Понижение сотрудника организации", "{78dbe2}Сотрудник: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}Дата понижения: {ffa000}"..date.."\n{78dbe2}Время понижения: {ffa000}"..time.."\n{78dbe2}Причина понижения: {ffa000}"..reason.."\n\n{78dbe2}Новая должность: {ffa000}["..(list+1).."] "..rank[list+1].."", "Док-ва", "Закрыть", DIALOG_STYLE_MSGBOX)
                                
                                while sampIsDialogActive(0) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(0)
                                if button == 1 then
                                    inputdocs()
                                    while sampIsDialogActive(2021) do wait(100) end
                                    local result, button, _, input = sampHasDialogRespond(2021)

                                    if button == 1 then
                                        docsi = input
                                        docs = ('\nДок-ва: '..docsi)
                                    end
                                end

                                
                                lfs.mkdir('moonloader/firedep_zam_helper/Отчеты о проделанной работе/Наказания/'..date.. ' ' ..timed.. ' ' ..nick.. ' (giverank-)')
                                file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                                file:write('[Понижение в должности]. Сотрудник: '..nick.. ' ['..id..'] Дата понижения: '..date..' Время понижения: '..time..' Новая должность: ['..(list+1)..'] '..rank[list+1]..' Принина: '..reason..'\n') --буфер откуда будет записывать инфу
                                file:close()

                                info = ('Понижение сотрудника. \n\nСотрудник: '..nick.. ' ['..id..'] \nДата понижения: '..date..' \nВремя понижения: '..time..' \nПричина: '..reason..''..docs)
                                docs = ''
                                img = 'photo-232454643_456239039'
                                sendvkimg(encodeUrl(info),img)
                            end
                            if button == 1 and list == 1 then
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                                sampProcessChatInput('/do На поясе закреплен КПК.', -1)
                                wait(1000)
                                sampProcessChatInput('/me снимает КПК с пояса и нажатием кнопки включает его', -1)
                                wait(1000)
                                sampProcessChatInput('/me посмотрела очет по проделанной работе '..nm, -1)
                                wait(1000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampProcessChatInput('/checkjobprogress '..id, -1)
                                wait(2000)
                                sampProcessChatInput('/me заходит в базу сотрудников и вводит изменения, после чего вешает КПК обратно на пояс', -1)
                                wait(1000)
                                sampProcessChatInput('/giverank '..id..' '..(list+1), -1)
                                wait(1000)
                                sampProcessChatInput('/r Сотрудник '..nm..' был понижен в должности до '..rank[list+1]..' по причине - '..reason, -1)
                                wait(2000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampShowDialog(0, "{FFA500}Понижение сотрудника организации", "{78dbe2}Сотрудник: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}Дата понижения: {ffa000}"..date.."\n{78dbe2}Время понижения: {ffa000}"..time.."\n{78dbe2}Причина понижения: {ffa000}"..reason.."\n\n{78dbe2}Новая должность: {ffa000}["..(list+1).."] "..rank[list+1].."", "Док-ва", "Закрыть", DIALOG_STYLE_MSGBOX)
                                
                                while sampIsDialogActive(0) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(0)
                                if button == 1 then
                                    inputdocs()
                                    while sampIsDialogActive(2021) do wait(100) end
                                    local result, button, _, input = sampHasDialogRespond(2021)

                                    if button == 1 then
                                        docsi = input
                                        docs = ('\nДок-ва: '..docsi)
                                    end
                                end

                                
                                lfs.mkdir('moonloader/firedep_zam_helper/Отчеты о проделанной работе/Наказания/'..date.. ' ' ..timed.. ' ' ..nick.. ' (giverank-)')
                                file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                                file:write('[Понижение в должности]. Сотрудник: '..nick.. ' ['..id..'] Дата понижения: '..date..' Время понижения: '..time..' Новая должность: ['..(list+1)..'] '..rank[list+1]..' Принина: '..reason..'\n') --буфер откуда будет записывать инфу
                                file:close()

                                info = ('Понижение сотрудника. \n\nСотрудник: '..nick.. ' ['..id..'] \nДата понижения: '..date..' \nВремя понижения: '..time..' \nПричина: '..reason..''..docs)
                                docs = ''
                                img = 'photo-232454643_456239039'
                                sendvkimg(encodeUrl(info),img)
                            end
                            if button == 1 and list == 2 then
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                                sampProcessChatInput('/do На поясе закреплен КПК.', -1)
                                wait(1000)
                                sampProcessChatInput('/me снимает КПК с пояса и нажатием кнопки включает его', -1)
                                wait(1000)
                                sampProcessChatInput('/me посмотрела очет по проделанной работе '..nm, -1)
                                wait(1000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampProcessChatInput('/checkjobprogress '..id, -1)
                                wait(2000)
                                sampProcessChatInput('/me заходит в базу сотрудников и вводит изменения, после чего вешает КПК обратно на пояс', -1)
                                wait(1000)
                                sampProcessChatInput('/giverank '..id..' '..(list+1), -1)
                                wait(1000)
                                sampProcessChatInput('/r Сотрудник '..nm..' был понижен в должности до '..rank[list+1]..' по причине - '..reason, -1)
                                wait(2000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampShowDialog(0, "{FFA500}Понижение сотрудника организации", "{78dbe2}Сотрудник: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}Дата понижения: {ffa000}"..date.."\n{78dbe2}Время понижения: {ffa000}"..time.."\n{78dbe2}Причина понижения: {ffa000}"..reason.."\n\n{78dbe2}Новая должность: {ffa000}["..(list+1).."] "..rank[list+1].."", "Док-ва", "Закрыть", DIALOG_STYLE_MSGBOX)
                                
                                while sampIsDialogActive(0) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(0)
                                if button == 1 then
                                    inputdocs()
                                    while sampIsDialogActive(2021) do wait(100) end
                                    local result, button, _, input = sampHasDialogRespond(2021)

                                    if button == 1 then
                                        docsi = input
                                        docs = ('\nДок-ва: '..docsi)
                                    end
                                end

                                
                                lfs.mkdir('moonloader/firedep_zam_helper/Отчеты о проделанной работе/Наказания/'..date.. ' ' ..timed.. ' ' ..nick.. ' (giverank-)')
                                file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                                file:write('[Понижение в должности]. Сотрудник: '..nick.. ' ['..id..'] Дата понижения: '..date..' Время понижения: '..time..' Новая должность: ['..(list+1)..'] '..rank[list+1]..' Принина: '..reason..'\n') --буфер откуда будет записывать инфу
                                file:close()

                                info = ('Понижение сотрудника. \n\nСотрудник: '..nick.. ' ['..id..'] \nДата понижения: '..date..' \nВремя понижения: '..time..' \nПричина: '..reason..''..docs)
                                docs = ''
                                img = 'photo-232454643_456239039'
                                sendvkimg(encodeUrl(info),img)
                            end
                            if button == 1 and list == 3 then
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                                sampProcessChatInput('/do На поясе закреплен КПК.', -1)
                                wait(1000)
                                sampProcessChatInput('/me снимает КПК с пояса и нажатием кнопки включает его', -1)
                                wait(1000)
                                sampProcessChatInput('/me посмотрела очет по проделанной работе '..nm, -1)
                                wait(1000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampProcessChatInput('/checkjobprogress '..id, -1)
                                wait(2000)
                                sampProcessChatInput('/me заходит в базу сотрудников и вводит изменения, после чего вешает КПК обратно на пояс', -1)
                                wait(1000)
                                sampProcessChatInput('/giverank '..id..' '..(list+1), -1)
                                wait(1000)
                                sampProcessChatInput('/r Сотрудник '..nm..' был понижен в должности до '..rank[list+1]..' по причине - '..reason, -1)
                                wait(2000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampShowDialog(0, "{FFA500}Понижение сотрудника организации", "{78dbe2}Сотрудник: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}Дата понижения: {ffa000}"..date.."\n{78dbe2}Время понижения: {ffa000}"..time.."\n{78dbe2}Причина понижения: {ffa000}"..reason.."\n\n{78dbe2}Новая должность: {ffa000}["..(list+1).."] "..rank[list+1].."", "Док-ва", "Закрыть", DIALOG_STYLE_MSGBOX)
                                
                                while sampIsDialogActive(0) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(0)
                                if button == 1 then
                                    inputdocs()
                                    while sampIsDialogActive(2021) do wait(100) end
                                    local result, button, _, input = sampHasDialogRespond(2021)

                                    if button == 1 then
                                        docsi = input
                                        docs = ('\nДок-ва: '..docsi)
                                    end
                                end

                                
                                lfs.mkdir('moonloader/firedep_zam_helper/Отчеты о проделанной работе/Наказания/'..date.. ' ' ..timed.. ' ' ..nick.. ' (giverank-)')
                                file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                                file:write('[Понижение в должности]. Сотрудник: '..nick.. ' ['..id..'] Дата понижения: '..date..' Время понижения: '..time..' Новая должность: ['..(list+1)..'] '..rank[list+1]..' Принина: '..reason..'\n') --буфер откуда будет записывать инфу
                                file:close()

                                info = ('Понижение сотрудника. \n\nСотрудник: '..nick.. ' ['..id..'] \nДата понижения: '..date..' \nВремя понижения: '..time..' \nПричина: '..reason..''..docs)
                                docs = ''
                                img = 'photo-232454643_456239039'
                                sendvkimg(encodeUrl(info),img)
                            end
                            if button == 1 and list == 4 then
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                                sampProcessChatInput('/do На поясе закреплен КПК.', -1)
                                wait(1000)
                                sampProcessChatInput('/me снимает КПК с пояса и нажатием кнопки включает его', -1)
                                wait(1000)
                                sampProcessChatInput('/me посмотрела очет по проделанной работе '..nm, -1)
                                wait(1000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampProcessChatInput('/checkjobprogress '..id, -1)
                                wait(2000)
                                sampProcessChatInput('/me заходит в базу сотрудников и вводит изменения, после чего вешает КПК обратно на пояс', -1)
                                wait(1000)
                                sampProcessChatInput('/giverank '..id..' '..(list+1), -1)
                                wait(1000)
                                sampProcessChatInput('/r Сотрудник '..nm..' был понижен в должности до '..rank[list+1]..' по причине - '..reason, -1)
                                wait(2000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampShowDialog(0, "{FFA500}Понижение сотрудника организации", "{78dbe2}Сотрудник: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}Дата понижения: {ffa000}"..date.."\n{78dbe2}Время понижения: {ffa000}"..time.."\n{78dbe2}Причина понижения: {ffa000}"..reason.."\n\n{78dbe2}Новая должность: {ffa000}["..(list+1).."] "..rank[list+1].."", "Док-ва", "Закрыть", DIALOG_STYLE_MSGBOX)
                                
                                while sampIsDialogActive(0) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(0)
                                if button == 1 then
                                    inputdocs()
                                    while sampIsDialogActive(2021) do wait(100) end
                                    local result, button, _, input = sampHasDialogRespond(2021)

                                    if button == 1 then
                                        docsi = input
                                        docs = ('\nДок-ва: '..docsi)
                                    end
                                end

                                
                                lfs.mkdir('moonloader/firedep_zam_helper/Отчеты о проделанной работе/Наказания/'..date.. ' ' ..timed.. ' ' ..nick.. ' (giverank-)')
                                file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                                file:write('[Понижение в должности]. Сотрудник: '..nick.. ' ['..id..'] Дата понижения: '..date..' Время понижения: '..time..' Новая должность: ['..(list+1)..'] '..rank[list+1]..' Принина: '..reason..'\n') --буфер откуда будет записывать инфу
                                file:close()

                                info = ('Понижение сотрудника. \n\nСотрудник: '..nick.. ' ['..id..'] \nДата понижения: '..date..' \nВремя понижения: '..time..' \nПричина: '..reason..''..docs)
                                docs = ''
                                img = 'photo-232454643_456239039'
                                sendvkimg(encodeUrl(info),img)
                            end
                            if button == 1 and list == 5 then
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                                sampProcessChatInput('/do На поясе закреплен КПК.', -1)
                                wait(1000)
                                sampProcessChatInput('/me снимает КПК с пояса и нажатием кнопки включает его', -1)
                                wait(1000)
                                sampProcessChatInput('/me посмотрела очет по проделанной работе '..nm, -1)
                                wait(1000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampProcessChatInput('/checkjobprogress '..id, -1)
                                wait(2000)
                                sampProcessChatInput('/me заходит в базу сотрудников и вводит изменения, после чего вешает КПК обратно на пояс', -1)
                                wait(1000)
                                sampProcessChatInput('/giverank '..id..' '..(list+1), -1)
                                wait(1000)
                                sampProcessChatInput('/r Сотрудник '..nm..' был понижен в должности до '..rank[list+1]..' по причине - '..reason, -1)
                                wait(2000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampShowDialog(0, "{FFA500}Понижение сотрудника организации", "{78dbe2}Сотрудник: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}Дата понижения: {ffa000}"..date.."\n{78dbe2}Время понижения: {ffa000}"..time.."\n{78dbe2}Причина понижения: {ffa000}"..reason.."\n\n{78dbe2}Новая должность: {ffa000}["..(list+1).."] "..rank[list+1].."", "Док-ва", "Закрыть", DIALOG_STYLE_MSGBOX)
                                
                                while sampIsDialogActive(0) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(0)
                                if button == 1 then
                                    inputdocs()
                                    while sampIsDialogActive(2021) do wait(100) end
                                    local result, button, _, input = sampHasDialogRespond(2021)

                                    if button == 1 then
                                        docsi = input
                                        docs = ('\nДок-ва: '..docsi)
                                    end
                                end

                                
                                lfs.mkdir('moonloader/firedep_zam_helper/Отчеты о проделанной работе/Наказания/'..date.. ' ' ..timed.. ' ' ..nick.. ' (giverank-)')
                                file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                                file:write('[Понижение в должности]. Сотрудник: '..nick.. ' ['..id..'] Дата понижения: '..date..' Время понижения: '..time..' Новая должность: ['..(list+1)..'] '..rank[list+1]..' Принина: '..reason..'\n') --буфер откуда будет записывать инфу
                                file:close()

                                info = ('Понижение сотрудника. \n\nСотрудник: '..nick.. ' ['..id..'] \nДата понижения: '..date..' \nВремя понижения: '..time..' \nПричина: '..reason..''..docs)
                                docs = ''
                                img = 'photo-232454643_456239039'
                                sendvkimg(encodeUrl(info),img)
                            end
                            if button == 1 and list == 6 then
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                                sampProcessChatInput('/do На поясе закреплен КПК.', -1)
                                wait(1000)
                                sampProcessChatInput('/me снимает КПК с пояса и нажатием кнопки включает его', -1)
                                wait(1000)
                                sampProcessChatInput('/me посмотрела очет по проделанной работе '..nm, -1)
                                wait(1000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampProcessChatInput('/checkjobprogress '..id, -1)
                                wait(2000)
                                sampProcessChatInput('/me заходит в базу сотрудников и вводит изменения, после чего вешает КПК обратно на пояс', -1)
                                wait(1000)
                                sampProcessChatInput('/giverank '..id..' '..(list+1), -1)
                                wait(1000)
                                sampProcessChatInput('/r Сотрудник '..nm..' был понижен в должности до '..rank[list+1]..' по причине - '..reason, -1)
                                wait(2000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampShowDialog(0, "{FFA500}Понижение сотрудника организации", "{78dbe2}Сотрудник: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}Дата понижения: {ffa000}"..date.."\n{78dbe2}Время понижения: {ffa000}"..time.."\n{78dbe2}Причина понижения: {ffa000}"..reason.."\n\n{78dbe2}Новая должность: {ffa000}["..(list+1).."] "..rank[list+1].."", "Док-ва", "Закрыть", DIALOG_STYLE_MSGBOX)
                                
                                while sampIsDialogActive(0) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(0)
                                if button == 1 then
                                    inputdocs()
                                    while sampIsDialogActive(2021) do wait(100) end
                                    local result, button, _, input = sampHasDialogRespond(2021)

                                    if button == 1 then
                                        docsi = input
                                        docs = ('\nДок-ва: '..docsi)
                                    end
                                end

                                
                                lfs.mkdir('moonloader/firedep_zam_helper/Отчеты о проделанной работе/Наказания/'..date.. ' ' ..timed.. ' ' ..nick.. ' (giverank-)')
                                file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                                file:write('[Понижение в должности]. Сотрудник: '..nick.. ' ['..id..'] Дата понижения: '..date..' Время понижения: '..time..' Новая должность: ['..(list+1)..'] '..rank[list+1]..' Принина: '..reason..'\n') --буфер откуда будет записывать инфу
                                file:close()

                                info = ('Понижение сотрудника. \n\nСотрудник: '..nick.. ' ['..id..'] \nДата понижения: '..date..' \nВремя понижения: '..time..' \nПричина: '..reason..''..docs)
                                docs = ''
                                img = 'photo-232454643_456239039'
                                sendvkimg(encodeUrl(info),img)
                            end
                            if button == 1 and list == 7 then
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                                sampProcessChatInput('/do На поясе закреплен КПК.', -1)
                                wait(1000)
                                sampProcessChatInput('/me снимает КПК с пояса и нажатием кнопки включает его', -1)
                                wait(1000)
                                sampProcessChatInput('/me посмотрела очет по проделанной работе '..nm, -1)
                                wait(1000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampProcessChatInput('/checkjobprogress '..id, -1)
                                wait(2000)
                                sampProcessChatInput('/me заходит в базу сотрудников и вводит изменения, после чего вешает КПК обратно на пояс', -1)
                                wait(1000)
                                sampProcessChatInput('/giverank '..id..' '..(list+1), -1)
                                wait(1000)
                                sampProcessChatInput('/r Сотрудник '..nm..' был понижен в должности до '..rank[list+1]..' по причине - '..reason, -1)
                                wait(2000)
                                sampProcessChatInput('/time', -1)
                                wait(2000)
                                sampShowDialog(0, "{FFA500}Понижение сотрудника организации", "{78dbe2}Сотрудник: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}Дата понижения: {ffa000}"..date.."\n{78dbe2}Время понижения: {ffa000}"..time.."\n{78dbe2}Причина понижения: {ffa000}"..reason.."\n\n{78dbe2}Новая должность: {ffa000}["..(list+1).."] "..rank[list+1].."", "Док-ва", "Закрыть", DIALOG_STYLE_MSGBOX)
                                
                                while sampIsDialogActive(0) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(0)
                                if button == 1 then
                                    inputdocs()
                                    while sampIsDialogActive(2021) do wait(100) end
                                    local result, button, _, input = sampHasDialogRespond(2021)

                                    if button == 1 then
                                        docsi = input
                                        docs = ('\nДок-ва: '..docsi)
                                    end
                                end

                                
                                lfs.mkdir('moonloader/firedep_zam_helper/Отчеты о проделанной работе/Наказания/'..date.. ' ' ..timed.. ' ' ..nick.. ' (giverank-)')
                                file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                                file:write('[Понижение в должности]. Сотрудник: '..nick.. ' ['..id..'] Дата понижения: '..date..' Время понижения: '..time..' Новая должность: ['..(list+1)..'] '..rank[list+1]..' Принина: '..reason..'\n') --буфер откуда будет записывать инфу
                                file:close()

                                info = ('Понижение сотрудника. \n\nСотрудник: '..nick.. ' ['..id..'] \nДата понижения: '..date..' \nВремя понижения: '..time..' \nПричина: '..reason..''..docs)
                                docs = ''
                                img = 'photo-232454643_456239039'
                                sendvkimg(encodeUrl(info),img)
                            end
                        end
                    end
                end

                -----------------------------------------------------------------------------------
                -- Выдать похвалу -----------------------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 11 then
                    inputid()
                    while sampIsDialogActive(2001) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(2001)

                    if button == 1 then
                        local id = input
                        local nick = sampGetPlayerNickname(id)
                        local nm = trst(nick)

                        inputreason()
                        while sampIsDialogActive(2005) do wait(100) end
                        local result, button, _, input = sampHasDialogRespond(2005)
                        
                        if button == 1 then
                            local reason = input

                            praisecount() -- !!!!!!!!!!!
                            while sampIsDialogActive(2011) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(2011)                        

                            if button == 1 then
                                local prisecount = input
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                                for i = 1, prisecount do
                                    sampProcessChatInput("/praise "..id.." "..reason,-1)
                                    wait(2000)
                                end
                                sampProcessChatInput('/time ',-1)

                                
                                lfs.mkdir('moonloader/firedep_zam_helper/Отчеты о проделанной работе/Похвалы/'..date.. ' ' ..timed.. ' ' ..nick.. ' (praise)')
                                file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                                file:write('[Выдача похвалы]. Сотрудник: '..nick.. ' ['..id..'] Дата выдачи: '..date..' Время выдачи: '..time..' Количество похвал: '..prisecount..' Принина: '..reason..'\n') --буфер откуда будет записывать инфу
                                file:close()

                                info = ('Выдача похвалы. \n\nСотрудник: '..nick.. ' ['..id..'] \nДата выдачи: '..date..' \nВремя выдачи: '..time..'\nКоличество похвалы: '..prisecount..'\nПринина: '..reason)
                                img = 'photo-232454643_456239040'
                                sendvkimg(encodeUrl(info),img)
                            end
                        end
                    end
                end

                -----------------------------------------------------------------------------------
                -- Вынести из черного списка ------------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 12 then
                    inputid()
                    while sampIsDialogActive(2001) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(2001)
                    
                    if button == 1 then
                    
                        local id = input
                        local nick = sampGetPlayerNickname(id)
                        local nm = trst(nick)
                        
                        inputreason()
                        while sampIsDialogActive(2005) do wait(100) end
                        local result, button, _, input = sampHasDialogRespond(2005)
                        if button == 1 then
                            local reason = input
                            local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                            local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                            sampProcessChatInput('/do На поясе закреплен КПК.', -1)
                            wait(1000)
                            sampProcessChatInput('/me снимает КПК с пояса и нажатием кнопки включает его', -1)
                            wait(1000)
                            sampProcessChatInput('/me заходит в базу данных организации, и выбирает пункт *Чёрный список*', -1)
                            wait(1000)
                            sampProcessChatInput('/me переходя в новую вкладку, в выбранном поле вписывает Имя и Фамилию человека', -1)
                            wait(1000)
                            sampProcessChatInput('/me нажимает на кнопку *Вынести*', -1)
                            wait(1000)
                            sampProcessChatInput('/me выключает КПК и вешает обратно на пояс', -1)
                            wait(1000)
                            sampProcessChatInput('/unblacklist '..id.. ' -1 '..reason, -1)
                            wait(1000)
                            sampProcessChatInput('/r Сотрудник '..nm..' был вынесен из черного списка организации.',-1)
                            wait(2000)
                            sampProcessChatInput('/time ',-1)
                            sampShowDialog(0, "{FFA500}Вынесение из ЧС ОРГ", "{78dbe2}Сотрудник: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}Дата вынесения: {ffa000}"..date.."\n{78dbe2}Время вынесения: {ffa000}"..time.."\n\n{78dbe2}Причина блокировки: {ffa000}"..reason, "Док-ва", "Закрыть", DIALOG_STYLE_MSGBOX)

                            while sampIsDialogActive(0) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(0)
                            if button == 1 then
                                inputdocs()
                                while sampIsDialogActive(2021) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(2021)

                                if button == 1 then
                                    docsi = input
                                    docs = ('\nДок-ва: '..docsi)
                                end
                            end
                            
                            lfs.mkdir('moonloader/firedep_zam_helper/Отчеты о проделанной работе/Наказания/'..date.. ' ' ..timed.. ' ' ..nick.. ' (unblacklist)')
                            file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                            file:write('[Вынесение из ЧС орг]. Сотрудник: '..nick.. ' ['..id..'] Дата вынесения: '..date..' Время вынесения: '..time..' Причина: '..reason..'\n') --буфер откуда будет записывать инфу
                            file:close()

                            info = ('Вынесение из ЧС орг. \n\nСотрудник: '..nick.. ' ['..id..'] \nДата вынесения: '..date..' \nВремя вынесения: '..time..' \nПричина: '..reason..''..docs)
                            docs = ''
                            img = 'photo-232454643_456239047'
                            sendvkimg(encodeUrl(info),img)
                        end
                    end
                end

                -----------------------------------------------------------------------------------
                -- Вынести из черный список (офлайн) ----------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 13 then
                    inputnick()
                    while sampIsDialogActive(2008) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(2008)
                    
                    if button == 1 then
                    
                        local nick = input
                        local nm = trst(nick)
                        
                        inputreason()
                        while sampIsDialogActive(2005) do wait(100) end
                        local result, button, _, input = sampHasDialogRespond(2005)
                        if button == 1 then
                            local reason = input
                            local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                            local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                            sampProcessChatInput('/do На поясе закреплен КПК.', -1)
                            wait(1000)
                            sampProcessChatInput('/me снимает КПК с пояса и нажатием кнопки включает его', -1)
                            wait(1000)
                            sampProcessChatInput('/me заходит в базу данных организации, и выбирает пункт *Чёрный список*', -1)
                            wait(1000)
                            sampProcessChatInput('/me переходя в новую вкладку, в выбранном поле вписывает Имя и Фамилию человека', -1)
                            wait(1000)
                            sampProcessChatInput('/me нажимает на кнопку *Вынести*', -1)
                            wait(1000)
                            sampProcessChatInput('/me выключает КПК и вешает обратно на пояс', -1)
                            wait(1000)
                            sampProcessChatInput('/unblacklistoff '..nick.. ' -1 '..reason, -1)
                            wait(1000)
                            sampProcessChatInput('/r Сотрудник '..nm..' был вынесен из черного списка организации.',-1)
                            wait(2000)
                            sampProcessChatInput('/time ',-1)
                            sampShowDialog(0, "{FFA500}Вынесение из ЧС ОРГ", "{78dbe2}Сотрудник: {ffa000}"..nick.." (офлайн)\n\n{78dbe2}Дата вынесения: {ffa000}"..date.."\n{78dbe2}Время вынесения: {ffa000}"..time.."\n\n{78dbe2}Причина вынесения: {ffa000}"..reason, "Док-ва", "Закрыть", DIALOG_STYLE_MSGBOX)

                            while sampIsDialogActive(0) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(0)
                            if button == 1 then
                                inputdocs()
                                while sampIsDialogActive(2021) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(2021)

                                if button == 1 then
                                    docsi = input
                                    docs = ('\nДок-ва: '..docsi)
                                end
                            end

                            lfs.mkdir('moonloader/firedep_zam_helper/Отчеты о проделанной работе/Наказания/'..date.. ' ' ..timed.. ' ' ..nick.. ' (unblacklistoff)')
                            file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
                            file:write('[Вынсение из ЧС орг]. Сотрудник: '..nick.. ' (офлайн) Дата вынесения: '..date..' Время вынесения: '..time..' Причина: '..reason..'\n') --буфер откуда будет записывать инфу
                            file:close()

                            info = ('Вынсение из ЧС орг. офлайн \n\nСотрудник: '..nick.. ' (офлайн) \nДата вынесения: '..date..' \nВремя вынесения: '..time..' \nПричина: '..reason..''..docs)
                            docs = ''
                            img = 'photo-232454643_456239047'
                            sendvkimg(encodeUrl(info),img)
                            
                        end
                    end
                end

                if button == 0 then zammenu() end
            end

            -----------------------------------------------------------------------------------
            -- Проверить работу сотрудника ----------------------------------------------------
            -----------------------------------------------------------------------------------
            if button == 1 and list == 1 then
                inputid()
                while sampIsDialogActive(2001) do wait(100) end
                local result, button, _, input = sampHasDialogRespond(2001)

                if button == 1 then
                    local id = input
                    local nick = sampGetPlayerNickname(id)
                    local nm = trst(nick)
                    local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                    local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))

                    sampProcessChatInput('/do На поясе закреплен КПК.', -1)
                    wait(1000)
                    sampProcessChatInput('/me снимает КПК с пояса и нажатием кнопки включает его', -1)
                    wait(1000)
                    sampProcessChatInput('/me посмотрела очет по проделанной работе '..nm, -1)
                    wait(1000)
                    sampProcessChatInput('/time', -1)
                    wait(1000)
                    sampProcessChatInput('/checkjobprogress '..id, -1)
                    wait(2000)

                    lfs.mkdir('moonloader/firedep_zam_helper/Отчеты о проделанной работе/Статистики/'..date.. ' ' ..timed.. ' ' ..nick.. ' (jobprogress)')
                end
            end

            -----------------------------------------------------------------------------------
            -- РП отыгровки (лекции / тренировки / уведомления) -------------------------------
            -----------------------------------------------------------------------------------
            if button == 1 and list == 2 then
                lua_thread.create(function()
                    lec()
                    while sampIsDialogActive(2006) do wait(100) end
                    local result, button, list, input = sampHasDialogRespond(2006)
                    
                    -----------------------------------------------------------------------------------
                    -- [RB] Памятка лоя всех ----------------------------------------------------------
                    -----------------------------------------------------------------------------------
                    if button == 1 and list == 0 then
                        sampProcessChatInput('/rb Уважаемые коллеги, сейчас будет небольшая шпаркалга:', -1)
                        wait(2000)
                        sampProcessChatInput('/rb 1. Запрещено выезжать на пожары вне зоны пожарного департамента. ', -1)
                        wait(2000)
                        sampProcessChatInput('/rb Исключение: в момент появления следующего пожара, вы находились...', -1)
                        wait(2000)
                        sampProcessChatInput('/rb ...на прошлом, или не успеете вернуться департамент.', -1)
                        wait(2000)
                        sampProcessChatInput('/rb 2. Воду можно набрать не только у департамента, но и из моря, подъехав...', -1)
                        wait(2000)
                        sampProcessChatInput('/rb ... аккуратно к нему.', -1)
                        wait(2000)
                        sampProcessChatInput('/rb 3. Для удобства отыгровок РП, существует хелпер пожарника.', -1)
                        wait(2000)
                        sampProcessChatInput('/rb 4. Рекомендую приссоединиться к спец. рации ВК, ссылка...', -1)
                        wait(2000)
                        sampProcessChatInput('/rb ...на оф. портале департамента.', -1)
                        wait(2000)
                        sampProcessChatInput('/rb 5. Пожары начинаются с 10 по мск, кд между пожарами 20 минут.', -1)
                        wait(2000)
                        sampProcessChatInput('/rb 6. Пожар третьего уровня проиходит раз в 3 часа, остальные в случайно.', -1)
                        wait(2000)
                        sampProcessChatInput('/rb 7. Рабочее время с 9 мск, не надо пустать с пожарами чтобы не огребстись.', -1)
                        wait(2000)
                        sampProcessChatInput('/rb 8. Если Вы начали прокачку по wbook, то до 5ого ранга...', -1)
                        wait(2000)
                        sampProcessChatInput('/rb ...Вы качаетесь только по нему.', -1)
                        wait(2000)
                        sampProcessChatInput('/rb 9. Полученные дисциплинарные взыскания необходимо отработать. ', -1)
                        wait(2000)
                        sampProcessChatInput('/rb Смотрите оф. портал. На этом пока всё, благодарю за внимание!', -1)
                    end

                    -----------------------------------------------------------------------------------
                    -- [R] Лекция про сон в раздевалке ------------------------------------------------
                    -----------------------------------------------------------------------------------
                    if button == 1 and list == 1 then
                        sampProcessChatInput('/r Уважаемые сотрудники, прошу минуточку внимания...',-1)
                        wait(1000)
                        sampProcessChatInput('/r Я хочу напомнить вам о том, что спать в раздевалке...',-1)
                        wait(1000)
                        sampProcessChatInput('/r В рабочее время запрещено.',-1)
                        wait(1000)
                        sampProcessChatInput('/r Также запрещено разгуливать вне департамента...',-1)
                        wait(1000)
                        sampProcessChatInput('/r в рабочей форме. Если поймаем вас на этом...',-1)
                        wait(1000)
                        sampProcessChatInput('/r Будут применены дисциплинарные меры.',-1)
                        wait(1000)
                        sampProcessChatInput('/r Спать в раздевалке можно только не в рабочее время.',-1)
                        wait(1000)
                        sampProcessChatInput('/r Во избежание получения дисциплинарных взысканий, рекомендую Вам ознакомится....',-1)
                        wait(1000)
                        sampProcessChatInput('/r ... с полным уставом, находящегося на официальном портале департамента.',-1)
                        wait(1000)
                        sampProcessChatInput('/r С уважением, заместитель начальника пожарного департамента - И. Краун.',-1)
                        wait(1000)
                        sampProcessChatInput('/r Спасибо что прослушали эту информацию.',-1)
                        wait(1000)
                        sampProcessChatInput('/r Хорошей службы!',-1)
                    end

                    -----------------------------------------------------------------------------------
                    -- [D] Информация для департамента по пожарной безопасности -----------------------
                    -----------------------------------------------------------------------------------
                    if button == 1 and list == 2 then
                        sampProcessChatInput('/d [FD] - [ALL]: Уважаемые коллеги, прошу минуточку внимания...', -1)
                        wait(1000)
                        sampProcessChatInput('/d [FD] - [ALL]: В связи участившимися случаями пожаров, просьба довести до личного состава...', -1)
                        wait(1000)
                        sampProcessChatInput('/d [FD] - [ALL]: правила обращения со средствами пожаротушения. ', -1)
                        wait(1000)
                        sampProcessChatInput('/d [FD] - [ALL]: Проверить актуальность планов пожарной эвакуации...', -1)
                        wait(1000)
                        sampProcessChatInput('/d [FD] - [ALL]: а также проверить техническое состояние огнетушителей...', -1)
                        wait(1000)
                        sampProcessChatInput('/d [FD] - [ALL]: и наличие средств оказания первой помощи.', -1)
                        wait(1000)
                        sampProcessChatInput('/d [FD] - [ALL]: У меня на этом всё, благодарю за внимание.', -1)
                        wait(1000)
                        sampProcessChatInput('/d [FD] - [ALL]: С уважением, заместитель начальника Пожарного департамента - И.Краун', -1)
                    end

                    -----------------------------------------------------------------------------------
                    -- [Лекция] Алгоритм действий пожарных при пожаре в здании ------------------------
                    -----------------------------------------------------------------------------------
                    if button == 1 and list == 3 then
                        sampProcessChatInput('Здравствуйте, уважаемые сотрудники.',-1)
                        wait(1000)
                        sampProcessChatInput('/s Сегодня разберем тему лекции: "Алгоритм действий пожарных при пожаре в здании.".',-1)
                        wait(3000)
                        sampProcessChatInput('/time',-1)
                        wait(3000)
                        sampProcessChatInput('Итак, начнем.',-1)
                        wait(1000)
                        sampProcessChatInput('Первое. Прибытие на место пожара: Уточните адрес, характер возгорания и информацию о пострадавших.',-1)
                        wait(1000)
                        sampProcessChatInput('По прибытии оцените масштаб пожара, угрозу для людей и близлежащих объектов, а также проверьте...',-1)
                        wait(1000)
                        sampProcessChatInput('...безопасность для команды.',-1)
                        wait(2000)
                        sampProcessChatInput('Второе. Эвакуация людей: Организуйте эвакуацию через основные или запасные выходы.',-1)
                        wait(1000)
                        sampProcessChatInput('Окажите помощь маломобильным людям, заблокированным в здании. Если эвакуация невозможна, обеспечьте подачу...',-1)
                        wait(1000)
                        sampProcessChatInput('свежего воздуха и успокойте пострадавших.',-1)
                        wait(2000)
                        sampProcessChatInput('Третье. Тушение пожара: Локализуйте очаг возгорания, используя доступные средства тушения.',-1)
                        wait(1000)
                        sampProcessChatInput('Пресекайте распространение огня на соседние помещения и этажи. При необходимости отключите...',-1)
                        wait(1000)
                        sampProcessChatInput('...электро- и газоснабжение.',-1)
                        wait(1000)
                        sampProcessChatInput('Четвертое. Завершение работы: Проверьте здание на наличие скрытых очагов возгорания и обеспечьте...',-1)
                        wait(2000)
                        sampProcessChatInput('...вентиляцию помещений.',-1)
                        wait(1000)
                        sampProcessChatInput('Убедитесь в отсутствии угрозы повторного возгорания. На этом лекция завершена.',-1)
                        wait(2000)
                        sampProcessChatInput('Спасибо за внимание.',-1)
                        wait(1000)
                        sampProcessChatInput('/s Лекция окончена. Можете быть свободны.',-1)
                        wait(3000)
                        sampProcessChatInput('/time',-1)
                    end

                    -----------------------------------------------------------------------------------
                    -- Провести инспекцию дома --------------------------------------------------------
                    -----------------------------------------------------------------------------------
                    if button == 1 and list == 4 then
                        idhouse()
                        while sampIsDialogActive(2018) do wait(200) end
                        local result, button, _, input = sampHasDialogRespond(2018)

                        if button == 1 then
                            local i = 0
                            local house = input
                            local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                            local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))
                            
                            lfs.mkdir('moonloader/firedep_zam_helper/Отчеты о проделанной работе/Инспекции домов/'..date.. ' ' ..timed.. ' Дом №' ..house)

                            sampProcessChatInput('/me приступила к инспекции дома №'..house, -1)
                            wait(1000)
                            sampProcessChatInput('/me зафиксировала время начала инспекции', -1)
                            wait(1000)
                            sampProcessChatInput('/do Время начала инспекции: '..time..'.', -1)
                            wait(2000)
                            sampProcessChatInput('/time', -1)
                            wait(5000)
                            sampProcessChatInput('/me достала бланк инспекции', -1)
                            wait(1000)
                            sampProcessChatInput('/do Бланк результатов инспекции в руке.', -1)
                            wait(1000)
                            sampProcessChatInput('/me проверила наличие огнетушителя в доме', -1)
                            wait(1000)
                            sampProcessChatInput('/try Огнетушитель на месте?', -1) 
                            wait(1000) i = i + inspect
                            
                            if inspect == 0 then
                                inspect_1 = '{AFEEEE}1. Наличие огнетушителя: {FF4500}Отсутсвтует'
                            else
                                inspect_1 = '{AFEEEE}1. Наличие огнетушителя: {7CFC00}Имеется'
                            end

                            sampProcessChatInput('/me сделала отметку в инспекционном листе', -1)
                            wait(1000)
                            sampProcessChatInput('/time', -1)
                            wait(5000)
                            sampProcessChatInput('/me проверила наличие аптечки', -1)
                            wait(1000)
                            sampProcessChatInput('/try Аптечка на месте?', -1)
                            wait(1000) i = i + inspect

                            if inspect == 0 then
                                inspect_2 = '{AFEEEE}2. Наличие аптечки: {FF4500}Отсутсвтует'
                            else
                                inspect_2 = '{AFEEEE}2. Наличие аптечки: {7CFC00}Имеется'
                            end

                            sampProcessChatInput('/me сделала отметку в инспекционном листе', -1)
                            wait(1000)
                            sampProcessChatInput('/time', -1)
                            wait(5000)
                            sampProcessChatInput('/me проверила наличие спасательной маски', -1)
                            wait(1000)
                            sampProcessChatInput('/try Спасательная маска на месте?', -1)
                            wait(1000) i = i + inspect

                            if inspect == 0 then
                                inspect_3 = '{AFEEEE}3. Наличие маски: {FF4500}Отсутсвтует'
                            else
                                inspect_3 = '{AFEEEE}3. Наличие маски: {7CFC00}Имеется'
                            end

                            sampProcessChatInput('/me сделала отметку в инспекционном листе', -1)
                            wait(1000)
                            sampProcessChatInput('/time', -1)
                            wait(5000)
                            sampProcessChatInput('/me проверила исправность системы пожарной сигнализации', -1)
                            wait(1000)
                            sampProcessChatInput('/try Пожарная сигнализация в исправном состоянии?', -1)
                            wait(1000) i = i + inspect

                            if inspect == 0 then
                                inspect_4 = '{AFEEEE}4. Пожарная сигнализация: {FF4500}Не исправна'
                            else
                                inspect_4 = '{AFEEEE}4. Пожарная сигнализация: {7CFC00}Исправна'
                            end

                            sampProcessChatInput('/me сделала отметку в инспекционном листе', -1)
                            wait(1000)
                            sampProcessChatInput('/time', -1)
                            wait(5000)
                            sampProcessChatInput('/me проверила запасной выход', -1)
                            wait(1000)
                            sampProcessChatInput('/try Запасной выход открыт?', -1)
                            wait(1000) i = i + inspect

                            if inspect == 0 then
                                inspect_5 = '{AFEEEE}5. Запасной выход: {FF4500}Заблокирован'
                            else
                                inspect_5 = '{AFEEEE}5. Запасной выход: {7CFC00}Открыт'
                            end

                            sampProcessChatInput('/me сделала отметку в инспекционном листе', -1)
                            wait(1000)
                            sampProcessChatInput('/time', -1)
                            wait(5000)
                            sampProcessChatInput('/me закончила инспекцию', -1)
                            wait(1000)
                            sampProcessChatInput('/do В руках бланк инспекции.', -1)
                            wait(1000)
                            sampProcessChatInput('/me поставила оценку дому по пожарной безопасности', -1)
                            wait(1000)
                            local date = os.date('%d.%m.%Y')
                            sampProcessChatInput('/do Оценка дому по результатам инспекции по пожарной безопасности '..i..' из 5', -1)
                            wait(2000)
                            sampProcessChatInput('/time', -1)
                            wait(5000)
                            sampProcessChatInput('/me поставила текущую дату '..date..' в поле дата', -1)
                            wait(1000)
                            sampProcessChatInput('/me поставила свою подпись в поле подпись', -1)
                            wait(1000)
                            sampProcessChatInput('/me зафиксировала время проверки', -1)
                            wait(1000)
                            local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                            sampProcessChatInput('/do Время завершения проверки: '..time..'.', -1)
                            wait(2000)
                            sampProcessChatInput('/time', -1)

                            if i < 3 then
                                ocenka = ('{FF4500}'..i)
                            elseif i == 3 then
                                ocenka = ('{FFA500}'..i)
                            elseif i > 3 then
                                ocenka = ('{7CFC00}'..i)
                            end

                            sampShowDialog(0, 'Карточка инспекции дома {FFA500}№'..house, '{48D1CC}Дата проверки: {FFA500}'..date..'\n{48D1CC}Время проверки: {FFA500}'..time..'\n\n{7FFFD4}Результаты проверки дома по пожарной безопасности:\n\n'..inspect_1..'\n'..inspect_2..'\n'..inspect_3..'\n'..inspect_4..'\n'..inspect_5..'\n\n{7FFFD4}Итоговая оценка дому по пожарной инспекции: '..ocenka..' из 5', 'Закрыть', '', DIALOG_STYLE_MSGBOX)
                        end
                    end

                    -----------------------------------------------------------------------------------
                    -- РП задания для сотрудников -----------------------------------------------------
                    -----------------------------------------------------------------------------------
                    if button == 1 and list == 6 then
                        rp()
                        while sampIsDialogActive(2009) do wait(200) end
                        local result, button, list, input = sampHasDialogRespond(2009)

                        if button == 1 and list == 0 then                            
                            inputid()
                            while sampIsDialogActive(2001) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(2001)

                            if button == 1 then
                                local id = input
                                local nick = sampGetPlayerNickname(id)
                                local nm = trst(nick)
                                sampProcessChatInput(nm..' для вас задание: помыть полы в холле департамента.',-1)
                                wait(1000)
                                sampProcessChatInput('/time',-1)
                            end
                        end

                        if button == 1 and list == 1 then                            
                            inputid()
                            while sampIsDialogActive(2001) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(2001)

                            if button == 1 then
                                local id = input
                                local nick = sampGetPlayerNickname(id)
                                local nm = trst(nick)
                                sampProcessChatInput(nm..' для вас задание: полить цветы в холле департамента.',-1)
                                wait(1000)
                                sampProcessChatInput('/time',-1)
                            end
                        end

                        if button == 1 and list == 2 then                            
                            inputid()
                            while sampIsDialogActive(2001) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(2001)

                            if button == 1 then
                                local id = input
                                local nick = sampGetPlayerNickname(id)
                                local nm = trst(nick)
                                sampProcessChatInput(nm..' для вас задание: проверить состояние огнетушителя в холле департамента.',-1)
                                wait(1000)
                                sampProcessChatInput('/time',-1)
                            end
                        end

                        if button == 1 and list == 3 then                            
                            inputid()
                            while sampIsDialogActive(2001) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(2001)

                            if button == 1 then
                                local id = input
                                local nick = sampGetPlayerNickname(id)
                                local nm = trst(nick)
                                sampProcessChatInput(nm..' для вас задание: заправить все свободные пожарные машины водой.',-1)
                                wait(1000)
                                sampProcessChatInput('/time',-1)
                            end
                        end

                        if button == 1 and list == 4 then                            
                            inputid()
                            while sampIsDialogActive(2001) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(2001)

                            if button == 1 then
                                local id = input
                                local nick = sampGetPlayerNickname(id)
                                local nm = trst(nick)
                                sampProcessChatInput(nm..' для вас задание: утилизировать старые личные дела в архиве.',-1)
                                wait(1000)
                                sampProcessChatInput('/time',-1)
                            end
                        end

                        if button == 1 and list == 5 then                            
                            inputid()
                            while sampIsDialogActive(2001) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(2001)

                            if button == 1 then
                                local id = input
                                local nick = sampGetPlayerNickname(id)
                                local nm = trst(nick)
                                sampProcessChatInput(nm..' для вас задание: протереть доску почета от пыли.',-1)
                                wait(1000)
                                sampProcessChatInput('/time',-1)
                            end
                        end

                        if button == 1 and list == 6 then                            
                            inputid()
                            while sampIsDialogActive(2001) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(2001)

                            if button == 1 then
                                local id = input
                                local nick = sampGetPlayerNickname(id)
                                local nm = trst(nick)
                                sampProcessChatInput(nm..' для вас задание: выбросить муссор из раздевалки пожарного департамента.',-1)
                                wait(1000)
                                sampProcessChatInput('/time',-1)
                            end
                        end
                    end

                    if button == 0 then zammenu() end

                end)
            end

            -----------------------------------------------------------------------------------
            -- Руссификатор ника --------------------------------------------------------------
            -----------------------------------------------------------------------------------
            if button == 1 and list == 4 then
                inputid()
                while sampIsDialogActive(2001) do wait(100) end
                local result, button, _, input = sampHasDialogRespond(2001)

                if button == 1 then
                    local id = input
                    local nick = sampGetPlayerNickname(id)
                    local nm = trst(nick)

                    setClipboardText(nm)
                    sampAddChatMessage('{78dbe2}Ник {ffa000}'..nm..' ['..id..'] {78dbe2}скопирован в буфер обмена', -1)
                end
            end

            -----------------------------------------------------------------------------------
            -- Скопировать ник для проверки на ЧСП и ЧСГос ------------------------------------
            -----------------------------------------------------------------------------------
            if button == 1 and list == 5 then
                inputid()
                while sampIsDialogActive(2001) do wait(100) end
                local result, button, _, input = sampHasDialogRespond(2001)

                if button == 1 then
                    local id = input
                    local nick = sampGetPlayerNickname(id)

                    setClipboardText(nick)
                    sampAddChatMessage('{78dbe2}Ник {ffa000}'..nick..' ['..id..'] {78dbe2}скопирован в буфер обмена', -1)
                end
            end

            -----------------------------------------------------------------------------------
            -- Проверка на НонРП ник ----------------------------------------------------------
            -----------------------------------------------------------------------------------
            if button == 1 and list == 6 then
                inputid()
                while sampIsDialogActive(2001) do wait(100) end
                local result, button, _, input = sampHasDialogRespond(2001)

                if button == 1 then
                    local id = input
                    local nick = '/checkrp '..sampGetPlayerNickname(id)

                    setClipboardText(nick)
                    sampAddChatMessage('{78dbe2}Команда {ffa000}'..nick..' {78dbe2}скопирована в буфер обмена', -1)
                end
            end

            -----------------------------------------------------------------------------------
            -- Таймеры ------------------------------------------------------------------------
            -----------------------------------------------------------------------------------
            if button == 1 and list == 7 then
                timermenu()
                while sampIsDialogActive(2017) do wait(100) end
                local result, button, list, input = sampHasDialogRespond(2017)

                -----------------------------------------------------------------------------------
                -- [5 мин] Таймер 5 минут для явки на работу --------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 0 then
                    inputid()
                    while sampIsDialogActive(2001) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(2001)

                    if button == 1 then
                        lua_thread.create(function()
                            local id = input
                            local nick = sampGetPlayerNickname(id)
                            local nm = trst(nick)
                            local time                          = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                            local timeend = os.date('%H:%M:%S', os.time() - (UTC * 3600)+(60*5))
                            sampProcessChatInput('/r '..nm.. ', у Вас есть 5 минут для того, чтобы надеть форму и приступить к работе.',-1)
                            wait(1000)
                            sampProcessChatInput('/r В случае игнорирования, к Вам будет применено дисциплинарное взыскание. Время пошло.',-1)
                            wait(1000)
                            sampShowDialog(0, "Таймер для {FFA500}"..nick, "{78dbe2}Время запуска:{FFA500} "..time.."\n{78dbe2}Время окончания:{FFA500} "..timeend.."\n\n{78dbe2}Сотрудник {FFA500}"..nick.." ["..id.."] \n{78dbe2}Время таймера: {FFA500}5 минут", "Закрыть","", DIALOG_STYLE_MSGBOX)
                            sampProcessChatInput('/time',-1)
                            wait(1000*60*2)
                            sampProcessChatInput('/time',-1)
                            sampShowDialog(0, "Таймер для {FFA500}"..nick, "{78dbe2}У сотрудника {FFA500}"..nick.." ["..id.."] {78dbe2}осталось {FFA500}3 минуты", "Закрыть", "", DIALOG_STYLE_MSGBOX)
                            wait(1000*60*3)
                            sampProcessChatInput('/time',-1)
                            sampShowDialog(0, "Таймер для {FFA500}"..nick, "{78dbe2}Время ожидания для сотрудника {FFA500}"..nick.." ["..id.."] {78dbe2}вышло.", "Закрыть", "", DIALOG_STYLE_MSGBOX)

                            local fire_1 = loadAudioStream("moonloader/firedep_zam_helper/alarm.mp3")
                            setAudioStreamState(fire_1, 1)
                        end)
                    end
                end
                
                -----------------------------------------------------------------------------------
                -- [1 мин] Таймер на 1 минуту -----------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 1 then
                    lua_thread.create(function()
                        local timer = 1
                        local time                          = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                        local timeend = os.date('%H:%M:%S', os.time() - (UTC * 3600)+(60*timer))
                        sampAddChatMessage('{FFFFFF}Таймер установлен на {FFA500}'..timer..' мин.',-1)
                        sampAddChatMessage('{FFFFFF}Запушен в {FFA500}'..time,-1)
                        sampAddChatMessage('{FFFFFF}Время окончания: {FFA500}'..timeend,-1)
                        sampProcessChatInput('/time',-1)
                        sampShowDialog(0, "Таймер", "{78dbe2}Таймер запущен в {FFA500}"..time.."\n\n{78dbe2}Время таймера: {FFA500}"..timer.." {78dbe2}мин.\nВремя окончания: {FFA500}"..timeend, "Закрыть", "", DIALOG_STYLE_MSGBOX)
                        wait(1000*60*timer)
                        sampProcessChatInput('/time',-1)
                        sampShowDialog(0, "Сработал таймер", "{78dbe2}Время таймера на {FFA500}"..timer.." {78dbe2}мин. вышло. {78dbe2}вышло.", "Закрыть", "", DIALOG_STYLE_MSGBOX)
                        
                        local fire_1 = loadAudioStream("moonloader/firedep_zam_helper/alarm.mp3")
                        setAudioStreamState(fire_1, 1)
                    end)
                end
                
                -----------------------------------------------------------------------------------
                -- [3 мин] Таймер на 3 минуты -----------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 2 then
                    lua_thread.create(function()
                        local timer = 3
                        local time                          = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                        local timeend = os.date('%H:%M:%S', os.time() - (UTC * 3600)+(60*timer))
                        sampAddChatMessage('{FFFFFF}Таймер установлен на {FFA500}'..timer..' мин.',-1)
                        sampAddChatMessage('{FFFFFF}Запушен в {FFA500}'..time,-1)
                        sampAddChatMessage('{FFFFFF}Время окончания: {FFA500}'..timeend,-1)
                        sampProcessChatInput('/time',-1)
                        sampShowDialog(0, "Таймер", "{78dbe2}Таймер запущен в {FFA500}"..time.."\n\n{78dbe2}Время таймера: {FFA500}"..timer.." {78dbe2}мин.\nВремя окончания: {FFA500}"..timeend, "Закрыть", "", DIALOG_STYLE_MSGBOX)
                        wait(1000*60*timer)
                        sampProcessChatInput('/time',-1)
                        sampShowDialog(0, "Сработал таймер", "{78dbe2}Время таймера на {FFA500}"..timer.." {78dbe2}мин. вышло. {78dbe2}вышло.", "Закрыть", "", DIALOG_STYLE_MSGBOX)
                    end)
                end
                
                -----------------------------------------------------------------------------------
                -- [5 мин] Таймер на 5 минут ------------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 3 then
                    lua_thread.create(function()
                        local timer = 5
                        local time                          = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                        local timeend = os.date('%H:%M:%S', os.time() - (UTC * 3600)+(60*timer))
                        sampAddChatMessage('{FFFFFF}Таймер установлен на {FFA500}'..timer..' мин.',-1)
                        sampAddChatMessage('{FFFFFF}Запушен в {FFA500}'..time,-1)
                        sampAddChatMessage('{FFFFFF}Время окончания: {FFA500}'..timeend,-1)
                        sampProcessChatInput('/time',-1)
                        sampShowDialog(0, "Таймер", "{78dbe2}Таймер запущен в {FFA500}"..time.."\n\n{78dbe2}Время таймера: {FFA500}"..timer.." {78dbe2}мин.\nВремя окончания: {FFA500}"..timeend, "Закрыть", "", DIALOG_STYLE_MSGBOX)
                        wait(1000*60*timer)
                        sampProcessChatInput('/time',-1)
                        sampShowDialog(0, "Сработал таймер", "{78dbe2}Время таймера на {FFA500}"..timer.." {78dbe2}мин. вышло. {78dbe2}вышло.", "Закрыть", "", DIALOG_STYLE_MSGBOX)
                    end)
                end
                
                -----------------------------------------------------------------------------------
                -- [Своё время] Установить таймер для игрока --------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 4 then
                    inputid()
                    while sampIsDialogActive(2001) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(2001)

                    if button == 1 then
                        local id = input

                        inputimer()
                        while sampIsDialogActive(2010) do wait(100) end
                        local result, button, _, input = sampHasDialogRespond(2010)

                        lua_thread.create(function()
                            local timer = input
                            local nick = sampGetPlayerNickname(id)
                            local nm = trst(nick)
                            local time                          = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                            local timeend = os.date('%H:%M:%S', os.time() - (UTC * 3600)+(60*timer))
                            sampShowDialog(0, "Таймер для {FFA500}"..nick, "{78dbe2}Время запуска:{FFA500} "..time.."\n{78dbe2}Время окончания:{FFA500} "..timeend.."\n\n{78dbe2}Сотрудник {FFA500}"..nick.." ["..id.."] \n{78dbe2}Время таймера: {FFA500}"..timer.." мин.", "Закрыть", "", DIALOG_STYLE_MSGBOX)
                            sampProcessChatInput('/time',-1)
                            wait(1000*60*timer)
                            sampProcessChatInput('/time',-1)
                            sampShowDialog(0, "Таймер для {FFA500}"..nick, "{78dbe2}Время ожидания для {FFA500}"..nick.." ["..id.."] {78dbe2}вышло.", "Закрыть", "", DIALOG_STYLE_MSGBOX)
                        end)
                    end
                end
                
                -----------------------------------------------------------------------------------
                -- [Своё время] Установить таймер для себя ----------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 5 then
                    inputimer()
                    while sampIsDialogActive(2010) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(2010)

                    if button == 1 then
                        lua_thread.create(function()
                            local timer = input
                            local time                          = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                            local timeend = os.date('%H:%M:%S', os.time() - (UTC * 3600)+(60*timer))
                            sampAddChatMessage('{FFFFFF}Таймер установлен на {FFA500}'..timer..' мин.',-1)
                            sampAddChatMessage('{FFFFFF}Запушен в {FFA500}'..time,-1)
                            sampAddChatMessage('{FFFFFF}Время окончания: {FFA500}'..timeend,-1)
                            sampProcessChatInput('/time',-1)
                            sampShowDialog(0, "Таймер", "{78dbe2}Таймер запущен в {FFA500}"..time.."\n\n{78dbe2}Время таймера: {FFA500}"..timer.." {78dbe2}мин.\nВремя окончания: {FFA500}"..timeend, "Закрыть", "", DIALOG_STYLE_MSGBOX)
                            wait(1000*60*timer)
                            sampProcessChatInput('/time',-1)
                            sampShowDialog(0, "Сработал таймер", "{78dbe2}Время таймера на {FFA500}"..timer.." {78dbe2}мин. вышло. {78dbe2}вышло.", "Закрыть", "", DIALOG_STYLE_MSGBOX)
                        end)
                    end
                end
                
                -----------------------------------------------------------------------------------
                -- [15 мин] Начать собеседование --------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 6 then
                    lua_thread.create(function()
                        local timer = 15
                        local time                          = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                        local timeend = os.date('%H:%M:%S', os.time() - (UTC * 3600)+(60*timer))
                        img = 'photo-232454643_456239043'
                        sendvkimg(encodeUrl('Собеседование начато.'),img)
                        sampAddChatMessage('{FFFFFF}Начато собеседование. Время собеседования {FFA500}'..timer..' минут',-1)
                        sampAddChatMessage('{FFFFFF}Запушен в {FFA500}'..time,-1)
                        sampAddChatMessage('{FFFFFF}Время окончания: {FFA500}'..timeend,-1)
                        sampProcessChatInput('/time',-1)
                        sampShowDialog(0, "Начало собеседования", "{78dbe2}Собеседование начато в {FFA500}"..time.."\n\n{78dbe2}Время собеседоваиня: {FFA500}"..timer.." {78dbe2}мин.\nВремя окончания: {FFA500}"..timeend, "Закрыть", "", DIALOG_STYLE_MSGBOX)
                        wait(1000*60*timer)
                        sampProcessChatInput('/do Собеседование окончено.',-1)
                        wait(2000)
                        sampProcessChatInput('/time',-1)
                        sampShowDialog(0, "Собеседование окончено", "{78dbe2}Время проведения собеседования {FFA500}окончено.", "Уведомить", "Закрыть", DIALOG_STYLE_MSGBOX)
                        
                        while sampIsDialogActive(0) do wait(100) end
                        local result, button, _, input = sampHasDialogRespond(0)
                        if button == 1 then
                           img = 'photo-232454643_456239044'
                           sendvkimg(encodeUrl('Собеседование окончено.'),img)
                        end

                    end)
                end

                if button == 0 then zammenu() end
            end

            -----------------------------------------------------------------------------------
            -- Заказать доставку ТС -----------------------------------------------------------
            -----------------------------------------------------------------------------------
            if button == 1 and list == 9 then
                sampProcessChatInput('/r Запрашиваю заправку служебного авто, просьба занять места.', -1)
                wait(5000)
                sampProcessChatInput('/r Заправка транспорта через 10 секунд.', -1)
                wait(5000)
                sampProcessChatInput('/r Заправка транспорта через 5 секунд.', -1)
                wait(5000)
                sampProcessChatInput('/r Заправка транспорта сейчас.', -1)
                sampProcessChatInput('/lmenu', -1)
            end

            -----------------------------------------------------------------------------------
            -- Назначить собес на ближ. время -------------------------------------------------
            -----------------------------------------------------------------------------------
            if button == 1 and list == 10 then
                start_sobes = true
                local hour = os.date('%H', os.time() - (3 * 3600))
                sobes = hour..',05,Пожарный департамент'
                sampAddChatMessage('{FFFFFF}Час собеседования: {FFA500}'..sobes,-1)
                --sampAddChatMessage('{FFFFFF}Час собеседования: {FFA500}'..h,-1)
                sampProcessChatInput('/lmenu', -1)
            end

            -----------------------------------------------------------------------------------
            -- Установить отдел игроку --------------------------------------------------------
            -----------------------------------------------------------------------------------
            if button == 1 and list == 11 then
                settag()
                while sampIsDialogActive(2020) do wait(100) end
                local result, button, list, input = sampHasDialogRespond(2020)
                
                if button == 1 and list == 0 then
                    inputid()
                    while sampIsDialogActive(2001) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(2001)
                    
                    if button == 1 then
                        local id = input
                        local tagname = string.gsub(string.match(sampGetPlayerNickname(id), "_%a+"), "_", "")
                        sampProcessChatInput('/settag '..id..' TD | '..tagname, -1)
                    end
                end

                if button == 1 and list == 1 then
                    inputid()
                    while sampIsDialogActive(2001) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(2001)
                    
                    if button == 1 then
                        local id = input
                        local tagname = string.gsub(string.match(sampGetPlayerNickname(id), "_%a+"), "_", "")
                        sampProcessChatInput('/settag '..id..' ID | '..tagname, -1)
                    end
                end

                if button == 1 and list == 2 then
                    inputid()
                    while sampIsDialogActive(2001) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(2001)
                    
                    if button == 1 then
                        local id = input
                        local tagname = string.gsub(string.match(sampGetPlayerNickname(id), "_%a+"), "_", "")
                        sampProcessChatInput('/settag '..id..' DA | '..tagname, -1)
                    end
                end

                if button == 1 and list == 3 then
                    inputid()
                    while sampIsDialogActive(2001) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(2001)
                    
                    if button == 1 then
                        local date = (os.date('%d.%m')+1)
                        local time = (os.date('%H:%M'))
                        local id = input
                        local name = sampGetPlayerNickname(id)
                        local tagname = string.gsub(string.match(name, "_%a+"), "_", "")
                        local nm = trst(name)
                        sampProcessChatInput('/settag '..id..' РПник до '..date, -1)
                        wait(1000)
                        sampProcessChatInput('/r '..nm.. ', Вам необходимо сменить имя в течении 24 часов. Иначе Вы будете уволены.', -1)
                        text = ('Игроку '..sampGetPlayerNickname(id).. ' ['..id..'] установлено требование:\nСменить НонРП ник до '..date..'.2025 '..time)
                        vkmsg(encodeUrl(text))
                    end
                end
            end

            -----------------------------------------------------------------------------------
            -- Отправить сообщение в диалог вк ------------------------------------------------
            -----------------------------------------------------------------------------------
            if button == 1 and list == 12 then
                inputmsg()
                while sampIsDialogActive(2022) do wait(100) end
                local result, button, _, input = sampHasDialogRespond(2022)
                if button == 1 then
                    local _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                    local nick = sampGetPlayerNickname(id)
                    local text = (nick..' ['..id..']: '..input)
                    vkmsg(encodeUrl(text))
                end
            end

            -----------------------------------------------------------------------------------
            -- Сообщение в диалог рук-ва ВК ---------------------------------------------------
            -----------------------------------------------------------------------------------
            if button == 1 and list == 13 then
                inputmsg()
                while sampIsDialogActive(2022) do wait(100) end
                local result, button, _, input = sampHasDialogRespond(2022)
                if button == 1 then
                    local _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                    local nick = sampGetPlayerNickname(id)
                    local text = (nick..' ['..id..']: '..input)

                    sendvkmsg(encodeUrl(text))
                end
            end

            -----------------------------------------------------------------------------------
            -- Совместные задания -------------------------------------------------------------
            -----------------------------------------------------------------------------------
            if button == 1 and list == 15 then
                zadmenu()
                while sampIsDialogActive(1000) do wait(100) end
                local result, button, list, input = sampHasDialogRespond(1000)

                -----------------------------------------------------------------------------------
                -- Добавить задание ---------------------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 0 then
                    zad()
                    while sampIsDialogActive(1001) do wait(100) end
                    local result, button, list, input = sampHasDialogRespond(1001)

                    if button == 1 and list == 0 then                                                                                       -- задание: выдать похвалу
                        inputnick()
                        while sampIsDialogActive(2008) do wait(100) end
                        local result, button, _, input = sampHasDialogRespond(2008)

                        if button == 1 then
                            local nick = input

                            praisecount()
                            while sampIsDialogActive(2011) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(2011)                        

                            if button == 1 then
                                local prisecount = input

                                inputreason()
                                while sampIsDialogActive(2002) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(2002)

                                if button == 1 then
                                    local reason = input
                                    local zadanie = ('Выдать похвалу '..nick)
                                    for i = 1, prisecount do
                                        local test = assert(conn:execute("SELECT COUNT(*) AS 'cnt' FROM zadlist"))
                                        local rowd = test:fetch({}, "a")
                                        local num = rowd.cnt
                                        local _, who_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                                        local autor = sampGetPlayerNickname(who_id)
                                        local command = ('/praise '..nick.. ' '..reason)

                                        assert(conn:execute("INSERT INTO zadlist (id,name,nick,command,reason,status,autor) VALUES ('"..num.."','"..zadanie.."', '"..nick.."', '"..command.."','"..reason.."','1','"..autor.."')"))
                                        sampAddChatMessage('Добавлено задание: {ffbf00}'..zadanie, -1)
                                    end
                                end
                            end
                        end
                    end

                    if button == 1 and list == 1 then                                                                                       -- задание: повысить сотрудника
                        inputnick()
                        while sampIsDialogActive(2008) do wait(100) end
                        local result, button, _, input = sampHasDialogRespond(2008)

                        if button == 1 then
                            local nick = input
                            local zadanie = ('Выдать повышение '..nick)

                            ranklist()
                            while sampIsDialogActive(2007) do wait(100) end
                            local result, button, list, input = sampHasDialogRespond(2007)
                            
                            if button == 1 then
                                local rank = list+1

                                inputreason()
                                while sampIsDialogActive(2005) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(2005)
                                
                                if button == 1 then
                                    local reason = input

                                    local test = assert(conn:execute("SELECT COUNT(*) AS 'cnt' FROM zadlist"))
                                    local rowd = test:fetch({}, "a")
                                    local num = rowd.cnt
                                    local _, who_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                                    local autor = sampGetPlayerNickname(who_id)
                                    local command = ('/giverank '..nick.. ' '..rank)

                                    assert(conn:execute("INSERT INTO zadlist (id,name,nick,command,reason,status,autor) VALUES ('"..num.."','"..zadanie.."', '"..nick.."', '"..command.."','"..reason.."','1','"..autor.."')"))
                                    sampAddChatMessage('Добавлено задание: {ffbf00}'..zadanie, -1)
                                end
                            end
                        end
                    end

                    if button == 1 and list == 2 then                                                                                       -- задание: принять в организацию
                        inputnick()
                        while sampIsDialogActive(2008) do wait(100) end
                        local result, button, _, input = sampHasDialogRespond(2008)

                        if button == 1 then
                            local nick = input
                            local zadanie = ('Принять в организацию '..nick..' на 4ый ранг')

                            inputreason()
                            while sampIsDialogActive(2005) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(2005)
                                
                            if button == 1 then
                                local reason = input
                                local test = assert(conn:execute("SELECT COUNT(*) AS 'cnt' FROM zadlist"))
                                local rowd = test:fetch({}, "a")
                                local num = rowd.cnt
                                local _, who_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                                local autor = sampGetPlayerNickname(who_id)
                                local command = ('/invite '..nick)

                                assert(conn:execute("INSERT INTO zadlist (id,name,nick,command,reason,status,autor) VALUES ('"..num.."','"..zadanie.."', '"..nick.."', '"..command.."','"..reason.."','1','"..autor.."')"))
                                sampAddChatMessage('Добавлено задание: {ffbf00}'..zadanie, -1)
                            end
                        end
                    end

                    if button == 1 and list == 3 then                                                                                       -- задание: выдать отдел
                        inputnick()
                        while sampIsDialogActive(2008) do wait(100) end
                        local result, button, _, input = sampHasDialogRespond(2008)

                        if button == 1 then
                            local nick = input
                            local zadanie = ('Выдать отдел '..nick)

                            inputreason()
                            while sampIsDialogActive(2005) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(2005)

                            if button == 1 then
                                local reason = input

                                settag()
                                while sampIsDialogActive(2020) do wait(100) end
                                local result, button, list, input = sampHasDialogRespond(2020)

                                if button == 1 and list == 0 then
                                    local tagname = string.gsub(string.match(nick, "_%a+"), "_", "")
                                    tag = 'TD | '..tagname
                                end

                                if button == 1 and list == 1 then
                                    local tagname = string.gsub(string.match(nick, "_%a+"), "_", "")
                                    tag = 'ID | '..tagname
                                end

                                if button == 1 and list == 2 then
                                    local tagname = string.gsub(string.match(nick, "_%a+"), "_", "")
                                    tag = 'DA | '..tagname
                                end

                                local test = assert(conn:execute("SELECT COUNT(*) AS 'cnt' FROM zadlist"))
                                local rowd = test:fetch({}, "a")
                                local num = rowd.cnt
                                local _, who_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                                local autor = sampGetPlayerNickname(who_id)
                                local command = ('/settag '..nick..' '..tag)

                                assert(conn:execute("INSERT INTO zadlist (id,name,nick,command,reason,status,autor) VALUES ('"..num.."','"..zadanie.."', '"..nick.."', '"..command.."','"..reason.."','1','"..autor.."')"))
                                sampAddChatMessage('Добавлено задание: {ffbf00}'..zadanie, -1)
                            end
                        end
                    end

                    if button == 1 and list == 4 then                                                                                       -- задание: выдать выговор
                        inputnick()
                        while sampIsDialogActive(2008) do wait(100) end
                        local result, button, _, input = sampHasDialogRespond(2008)

                        if button == 1 then
                            local nick = input
                            local zadanie = ('Выдать выговор '..nick)

                            inputreason()
                            while sampIsDialogActive(2005) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(2005)

                            if button == 1 then
                                local reason = input
                                local test = assert(conn:execute("SELECT COUNT(*) AS 'cnt' FROM zadlist"))
                                local rowd = test:fetch({}, "a")
                                local num = rowd.cnt
                                local _, who_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                                local autor = sampGetPlayerNickname(who_id)
                                local command = ('/fwarn '..nick..' '..reason)

                                assert(conn:execute("INSERT INTO zadlist (id,name,nick,command,reason,status,autor) VALUES ('"..num.."','"..zadanie.."', '"..nick.."', '"..command.."','"..reason.."','1','"..autor.."')"))
                                sampAddChatMessage('Добавлено задание: {ffbf00}'..zadanie, -1)
                            end
                        end
                    end

                    if button == 1 and list == 5 then                                                                                       -- задание: уволить из организации
                        inputnick()
                        while sampIsDialogActive(2008) do wait(100) end
                        local result, button, _, input = sampHasDialogRespond(2008)

                        if button == 1 then
                            local nick = input
                            local zadanie = ('Уволить из организации '..nick)

                            inputreason()
                            while sampIsDialogActive(2005) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(2005)

                            if button == 1 then
                                local reason = input
                                local test = assert(conn:execute("SELECT COUNT(*) AS 'cnt' FROM zadlist"))
                                local rowd = test:fetch({}, "a")
                                local num = rowd.cnt
                                local _, who_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                                local autor = sampGetPlayerNickname(who_id)
                                local command = ('/uninvite '..nick..' '..reason)

                                assert(conn:execute("INSERT INTO zadlist (id,name,nick,command,reason,status,autor) VALUES ('"..num.."','"..zadanie.."', '"..nick.."', '"..command.."','"..reason.."','1','"..autor.."')"))
                                sampAddChatMessage('Добавлено задание: {ffbf00}'..zadanie, -1)
                            end
                        end
                    end

                    if button == 1 and list == 6 then                                                                                       -- задание: занести в черный список
                        inputnick()
                        while sampIsDialogActive(2008) do wait(100) end
                        local result, button, _, input = sampHasDialogRespond(2008)

                        if button == 1 then
                            local nick = input
                            local zadanie = ('Занести в ЧС организации '..nick)

                            inputreason()
                            while sampIsDialogActive(2005) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(2005)

                            if button == 1 then
                                local reason = input
                                local test = assert(conn:execute("SELECT COUNT(*) AS 'cnt' FROM zadlist"))
                                local rowd = test:fetch({}, "a")
                                local num = rowd.cnt
                                local _, who_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                                local autor = sampGetPlayerNickname(who_id)
                                local command = ('/blacklist '..nick..' '..reason)

                                assert(conn:execute("INSERT INTO zadlist (id,name,nick,command,reason,status,autor) VALUES ('"..num.."','"..zadanie.."', '"..nick.."', '"..command.."','"..reason.."','1','"..autor.."')"))
                                sampAddChatMessage('Добавлено задание: {ffbf00}'..zadanie, -1)
                            end
                        end
                    end

                    local cursor = assert(conn:execute("SELECT * FROM zadlist ORDER by uid ASC"))
                    local row = cursor:fetch({}, "a")
                    local cnt = 0
                    while row do
                        assert(conn:execute("UPDATE zadlist SET id = '"..cnt.."' WHERE uid = '"..row.uid.."'"))
                        row = cursor:fetch({}, "a")
                        cnt = cnt+1
                    end

                    if button == 0 then
                        zadmenu()
                    end
                end

                -----------------------------------------------------------------------------------
                -- Выполнить задание --------------------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 1 then
                    local cursor = assert(conn:execute("SELECT * FROM zadlist ORDER by id DESC"))
                    local row = cursor:fetch({}, "a")
                    local list = ''
                    local cnt = 0
                    
                    while row do
                        cnt = cnt+1
                        list = row.name..'\n'..list
                        row = cursor:fetch({}, "a")
                    end

                    zadlist(logo, list)
                    while sampIsDialogActive(9999) do wait(100) end
                    local result, button, list, input = sampHasDialogRespond(9999)

                    for i=0, cnt-1  do
                        if button == 1 and list == i then
                            local cursor = assert(conn:execute("SELECT * FROM zadlist WHERE id = '"..i.."'"))
                            local row = cursor:fetch({}, "a")

                            if row.name:match('похвалу') then                                                                                            -- если выполнить задание: выдать похвалу
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local date = os.date('%d.%m.%Y')
                                local datetime = (date..' '..time)
                                local id = sampGetPlayerIdByNickname(row.nick)
                                local _, who_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                                local who_nick = sampGetPlayerNickname(who_id)
                                local who_add = (who_nick..' ['..who_id..']')

                                assert(conn:execute("DELETE FROM zadlist WHERE id = '"..row.id.."'"))
                                assert(conn:execute("INSERT INTO history (datetime, who_nick, zadanie, command, reason, nick, autor) VALUES ('"..datetime.."', '"..who_add.."', '"..row.name.."', '"..row.command.."', '"..row.reason.."', '"..row.nick.."', '"..row.autor.."')"))
                                
                                sampProcessChatInput("/praise "..id.." "..row.reason,-1)
                                sampProcessChatInput('/time ',-1)

                                sampAddChatMessage('Задание: {ffad33}'..row.name..' {FFFFFF}ВЫПОЛНЕНО', -1)

                                info_2 = ('Выдача похвалы. \n\nСотрудник: '..row.nick.. ' ['..id..'] \nДата выдачи: '..date..' \nВремя выдачи: '..time..'\nКоличество похвалы: 1\nПринина: '..row.reason..'\n\nСоздал задание: '..row.autor..'\nВыполнил: '..who_nick..' ['..who_id..']')
                                img = 'photo-232454643_456239040'
                                sendvkimg(encodeUrl(info_2),img)

                                local cursor = assert(conn:execute("SELECT * FROM zadlist ORDER by uid ASC"))
                                local row = cursor:fetch({}, "a")
                                local cnt = 0
                                while row do
                                    assert(conn:execute("UPDATE zadlist SET id = '"..cnt.."' WHERE uid = '"..row.uid.."'"))
                                    row = cursor:fetch({}, "a")
                                    cnt = cnt+1
                                end
                            end

                            if row.name:match('повышение') then                                                                                           -- если выполнить задание: выдать повышение
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local date = os.date('%d.%m.%Y')
                                local datetime = (date..' '..time)
                                local id = sampGetPlayerIdByNickname(row.nick)
                                local _, who_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                                local who_nick = sampGetPlayerNickname(who_id)
                                local who_add = (who_nick..' ['..who_id..']')

                                assert(conn:execute("DELETE FROM zadlist WHERE id = '"..row.id.."'"))
                                assert(conn:execute("INSERT INTO history (datetime, who_nick, zadanie, command, reason, nick, autor) VALUES ('"..datetime.."', '"..who_add.."', '"..row.name.."', '"..row.command.."', '"..row.reason.."', '"..row.nick.."', '"..row.autor.."')"))
                                
                                sampProcessChatInput(row.command,-1)
                                sampProcessChatInput('/time ',-1)

                                sampAddChatMessage('Задание: {ffad33}'..row.name..' {FFFFFF}ВЫПОЛНЕНО', -1)

                                info_2 = ('Выдача повышения. \n\nСотрудник: '..row.nick.. ' ['..id..'] \nДата повышения: '..date..' \nВремя повышения: '..time..'\nПринина: '..row.reason..'\n\nСоздал задание: '..row.autor..'\nВыполнил: '..who_nick..' ['..who_id..']')
                                img = 'photo-232454643_456239038'
                                sendvkimg(encodeUrl(info_2),img)

                                local cursor = assert(conn:execute("SELECT * FROM zadlist ORDER by uid ASC"))
                                local row = cursor:fetch({}, "a")
                                local cnt = 0
                                while row do
                                    assert(conn:execute("UPDATE zadlist SET id = '"..cnt.."' WHERE uid = '"..row.uid.."'"))
                                    row = cursor:fetch({}, "a")
                                    cnt = cnt+1
                                end
                            end

                            if row.name:match('Принять') then                                                                                            -- если выполнить задание: принять в организацию
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local date = os.date('%d.%m.%Y')
                                local datetime = (date..' '..time)
                                local id = sampGetPlayerIdByNickname(row.nick)
                                local nick = row.nick 
                                local _, who_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                                local who_nick = sampGetPlayerNickname(who_id)
                                local who_add = (who_nick..' ['..who_id..']')
                                local nm = trst(nick)

                                sampProcessChatInput('/do Сумка с формой на плече.',-1)
                                wait(1000)
                                sampProcessChatInput('/me положил сумку на пол и растегнул',-1)
                                wait(1000)
                                sampProcessChatInput('/do Сумка в открытом виде лежит на полу.',-1)
                                wait(1000)
                                sampProcessChatInput('/me взял форму и передал человеку напротив',-1)
                                wait(1000)
                                sampProcessChatInput(row.command,-1)
                                wait(1000)
                                sampProcessChatInput('/time ',-1)
                                wait(2000)
                                waitrp(id, nick)
                                while sampIsDialogActive(2004) do wait(100) end
                                local result, button, _, input = sampHasDialogRespond(2004)
                                if button == 1 then
                                    assert(conn:execute("DELETE FROM zadlist WHERE id = '"..row.id.."'"))
                                    assert(conn:execute("INSERT INTO history (datetime, who_nick, zadanie, command, reason, nick, autor) VALUES ('"..datetime.."', '"..who_add.."', '"..row.name.."', '"..row.command.."', '"..row.reason.."', '"..row.nick.."', '"..row.autor.."')"))

                                    sampProcessChatInput('/fractionrp '..id,-1)
                                    wait(2000)
                                    sampProcessChatInput('/r Приветствуем нового сотрудника пожарного департамента - '..nm..'.',-1)
                                    wait(2000)
                                    sampProcessChatInput('/time ',-1)
                                    wait(2000)
                                    sampProcessChatInput('/do На поясе закреплен КПК.', -1)
                                    wait(1000)
                                    sampProcessChatInput('/me снимает КПК с пояса и нажатием кнопки включает его', -1)
                                    wait(1000)
                                    sampProcessChatInput('/me заходит в базу сотрудников и вводит изменения, после чего вешает КПК обратно на пояс', -1)
                                    wait(1000)
                                    sampProcessChatInput('/giverank '..id..' 4', -1)
                                    wait(1000)
                                    sampProcessChatInput('/r Сотрудник '..nm..' получил новую должность - Пожарный.', -1)
                                    wait(2000)
                                    sampProcessChatInput('/time', -1)

                                    info_2 = ('Принятие в организацию. \n\nСотрудник: '..row.nick.. ' ['..id..'] \nДата принятия: '..date..' \nВремя принятия: '..time..'\nПринина: '..row.reason..'\n\nСоздал задание: '..row.autor..'\nВыполнил: '..who_nick..' ['..who_id..']')
                                    img = 'photo-232454643_456239037'
                                    sendvkimg(encodeUrl(info_2),img)

                                    local cursor = assert(conn:execute("SELECT * FROM zadlist ORDER by uid ASC"))
                                    local row = cursor:fetch({}, "a")
                                    local cnt = 0
                                    while row do
                                        assert(conn:execute("UPDATE zadlist SET id = '"..cnt.."' WHERE uid = '"..row.uid.."'"))
                                        row = cursor:fetch({}, "a")
                                        cnt = cnt+1
                                    end
                                end
                            end

                            if row.name:match('отдел') then                                                                                              -- если выполнить задание: выдать отдел
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local date = os.date('%d.%m.%Y')
                                local datetime = (date..' '..time)
                                local id = sampGetPlayerIdByNickname(row.nick)
                                local _, who_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                                local who_nick = sampGetPlayerNickname(who_id)
                                local who_add = (who_nick..' ['..who_id..']')

                                assert(conn:execute("DELETE FROM zadlist WHERE id = '"..row.id.."'"))
                                assert(conn:execute("INSERT INTO history (datetime, who_nick, zadanie, command, reason, nick, autor) VALUES ('"..datetime.."', '"..who_add.."', '"..row.name.."', '"..row.command.."', '"..row.reason.."', '"..row.nick.."', '"..row.autor.."')"))
                                
                                sampProcessChatInput(row.command,-1)
                                sampProcessChatInput('/time ',-1)

                                sampAddChatMessage('Задание: {ffad33}'..row.name..' {FFFFFF}ВЫПОЛНЕНО', -1)

                                info_2 = ('Выдать отдел. \n\nСотрудник: '..row.nick.. ' ['..id..'] \nДата выполнения: '..date..' \nВремя выполнения: '..time..'\nПринина: '..row.reason..'\n\nСоздал задание: '..row.autor..'\nВыполнил: '..who_nick..' ['..who_id..']')
                                img = 'photo-232454643_456239038'
                                sendvkimg(encodeUrl(info_2),img)

                                local cursor = assert(conn:execute("SELECT * FROM zadlist ORDER by uid ASC"))
                                local row = cursor:fetch({}, "a")
                                local cnt = 0
                                while row do
                                    assert(conn:execute("UPDATE zadlist SET id = '"..cnt.."' WHERE uid = '"..row.uid.."'"))
                                    row = cursor:fetch({}, "a")
                                    cnt = cnt+1
                                end
                            end

                            if row.name:match('выговор') then                                                                                            -- если выполнить задание: выдать выговор
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local date = os.date('%d.%m.%Y')
                                local datetime = (date..' '..time)
                                local id = sampGetPlayerIdByNickname(row.nick)
                                local _, who_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                                local who_nick = sampGetPlayerNickname(who_id)
                                local who_add = (who_nick..' ['..who_id..']')

                                assert(conn:execute("DELETE FROM zadlist WHERE id = '"..row.id.."'"))
                                assert(conn:execute("INSERT INTO history (datetime, who_nick, zadanie, command, reason, nick, autor) VALUES ('"..datetime.."', '"..who_add.."', '"..row.name.."', '"..row.command.."', '"..row.reason.."', '"..row.nick.."', '"..row.autor.."')"))
                                
                                sampProcessChatInput(row.command,-1)
                                sampProcessChatInput('/time ',-1)

                                sampAddChatMessage('Задание: {ffad33}'..row.name..' {FFFFFF}ВЫПОЛНЕНО', -1)

                                info_2 = ('Выдача выговора. \n\nСотрудник: '..row.nick.. ' ['..id..'] \nДата выговора: '..date..' \nВремя выговора: '..time..'\nПринина: '..row.reason..'\n\nСоздал задание: '..row.autor..'\nВыполнил: '..who_nick..' ['..who_id..']')
                                img = 'photo-232454643_456239035'
                                sendvkimg(encodeUrl(info_2),img)

                                local cursor = assert(conn:execute("SELECT * FROM zadlist ORDER by uid ASC"))
                                local row = cursor:fetch({}, "a")
                                local cnt = 0
                                while row do
                                    assert(conn:execute("UPDATE zadlist SET id = '"..cnt.."' WHERE uid = '"..row.uid.."'"))
                                    row = cursor:fetch({}, "a")
                                    cnt = cnt+1
                                end
                            end

                            if row.name:match('Уволить') then                                                                                            -- если выполнить задание: Уволить из организации
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local date = os.date('%d.%m.%Y')
                                local datetime = (date..' '..time)
                                local id = sampGetPlayerIdByNickname(row.nick)
                                local _, who_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                                local who_nick = sampGetPlayerNickname(who_id)
                                local who_add = (who_nick..' ['..who_id..']')

                              --assert(conn:execute("DELETE FROM zadlist WHERE id = '"..row.id.."'"))
                                assert(conn:execute("INSERT INTO history (datetime, who_nick, zadanie, command, reason, nick, autor) VALUES ('"..datetime.."', '"..who_add.."', '"..row.name.."', '"..row.command.."', '"..row.reason.."', '"..row.nick.."', '"..row.autor.."')"))
                                
                                sampProcessChatInput(row.command,-1)
                                sampProcessChatInput('/time ',-1)

                                sampAddChatMessage('Задание: {ffad33}'..row.name..' {FFFFFF}ВЫПОЛНЕНО', -1)

                                info_2 = ('Увольнение из организации отдел. \n\nСотрудник: '..row.nick.. ' ['..id..'] \nДата увольнения: '..date..' \nВремя увольнения: '..time..'\nПринина: '..row.reason..'\n\nСоздал задание: '..row.autor..'\nВыполнил: '..who_nick..' ['..who_id..']')
                                img = 'photo-232454643_456239045'
                                sendvkimg(encodeUrl(info_2),img)

                                local cursor = assert(conn:execute("SELECT * FROM zadlist ORDER by uid ASC"))
                                local row = cursor:fetch({}, "a")
                                local cnt = 0
                                while row do
                                    assert(conn:execute("UPDATE zadlist SET id = '"..cnt.."' WHERE uid = '"..row.uid.."'"))
                                    row = cursor:fetch({}, "a")
                                    cnt = cnt+1
                                end
                            end

                            if row.name:match('список') then                                                                                             -- если выполнить задание: внести в черный список
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local date = os.date('%d.%m.%Y')
                                local datetime = (date..' '..time)
                                local id = sampGetPlayerIdByNickname(row.nick)
                                local _, who_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                                local who_nick = sampGetPlayerNickname(who_id)
                                local who_add = (who_nick..' ['..who_id..']')

                                assert(conn:execute("DELETE FROM zadlist WHERE id = '"..row.id.."'"))
                                assert(conn:execute("INSERT INTO history (datetime, who_nick, zadanie, command, reason, nick, autor) VALUES ('"..datetime.."', '"..who_add.."', '"..row.name.."', '"..row.command.."', '"..row.reason.."', '"..row.nick.."', '"..row.autor.."')"))
                                
                                sampProcessChatInput(row.command,-1)
                                sampProcessChatInput('/time ',-1)

                                sampAddChatMessage('Задание: {ffad33}'..row.name..' {FFFFFF}ВЫПОЛНЕНО', -1)

                                info_2 = ('Внесение в черный список. \n\nСотрудник: '..row.nick.. ' ['..id..'] \nДата внесения: '..date..' \nВремя внесения: '..time..'\nПринина: '..row.reason..'\n\nСоздал задание: '..row.autor..'\nВыполнил: '..who_nick..' ['..who_id..']')
                                img = 'photo-232454643_456239046'
                                sendvkimg(encodeUrl(info_2),img)

                                local cursor = assert(conn:execute("SELECT * FROM zadlist ORDER by uid ASC"))
                                local row = cursor:fetch({}, "a")
                                local cnt = 0
                                while row do
                                    assert(conn:execute("UPDATE zadlist SET id = '"..cnt.."' WHERE uid = '"..row.uid.."'"))
                                    row = cursor:fetch({}, "a")
                                    cnt = cnt+1
                                end
                            end

                            if row.name:match('первый') then                                                                                             -- если выполнить задание: внести в черный список
                                local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                                local date = os.date('%d.%m.%Y')
                                local datetime = (date..' '..time)
                                local id = sampGetPlayerIdByNickname(row.nick)
                                local _, who_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                                local who_nick = sampGetPlayerNickname(who_id)
                                local who_add = (who_nick..' ['..who_id..']')

                                assert(conn:execute("DELETE FROM zadlist WHERE id = '"..row.id.."'"))
                                assert(conn:execute("INSERT INTO history (datetime, who_nick, zadanie, command, reason, nick, autor) VALUES ('"..datetime.."', '"..who_add.."', '"..row.name.."', '"..row.command.."', '"..row.reason.."', '"..row.nick.."', '"..row.autor.."')"))
                                
                                sampProcessChatInput(row.command,-1)
                                sampProcessChatInput('/time ',-1)

                                sampAddChatMessage('Задание: {ffad33}'..row.name..' {FFFFFF}ВЫПОЛНЕНО', -1)

                                info_2 = ('Получение награды. \n\nДата выполнения: '..date..' \nВремя выполнения: '..time..'\n\nСоздал задание: '..row.autor..'\nВыполнил первым: '..who_nick..' ['..who_id..']')
                                img = 'photo-232454643_456239048'
                                sendvkmsgtest(encodeUrl(info_2),img)

                                local cursor = assert(conn:execute("SELECT * FROM zadlist ORDER by uid ASC"))
                                local row = cursor:fetch({}, "a")
                                local cnt = 0
                                while row do
                                    assert(conn:execute("UPDATE zadlist SET id = '"..cnt.."' WHERE uid = '"..row.uid.."'"))
                                    row = cursor:fetch({}, "a")
                                    cnt = cnt+1
                                end
                            end
                        end
                    end

                    if button == 0 then
                        zadmenu()
                    end
                end

                -----------------------------------------------------------------------------------
                -- Удалить задание ----------------------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 2 then
                    local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
                    local date = os.date('%d.%m.%Y')
                    local datetime = (date..' '..time)
                    local _, who_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                    local who_nick = sampGetPlayerNickname(who_id)
                    local who_add = (who_nick..' ['..who_id..']')

                    local cursor = assert(conn:execute("SELECT * FROM zadlist ORDER by id DESC"))
                    local row = cursor:fetch({}, "a")
                    local list = ''
                    local cnt = 0
                    
                    while row do                                                                                 
                        cnt = cnt+1
                        list = row.name..'\n'..list
                        row = cursor:fetch({}, "a")
                    end

                    zadlist(logo, list)
                    while sampIsDialogActive(9999) do wait(100) end
                    local result, button, list, input = sampHasDialogRespond(9999)

                    for i=0, cnt-1  do
                        if button == 1 and list == i then
                            
                            local cursor = assert(conn:execute("SELECT * FROM zadlist WHERE id = '"..i.."'"))
                            local row = cursor:fetch({}, "a")
                            while row do
                                --assert(conn:execute("INSERT INTO history (datetime, who_nick, zadanie, command, reason, nick) VALUES ('"..datetime.."', '"..who_add.."', '"..row.name.."', '-', '-', '-')"))
                                assert(conn:execute("DELETE FROM zadlist WHERE id = '"..i.."'"))
                                row = cursor:fetch({}, "a")
                            end
                            
                            local cursor = assert(conn:execute("SELECT * FROM zadlist ORDER by uid ASC"))
                            local row = cursor:fetch({}, "a")
                            local cnt = 0
                            while row do
                                assert(conn:execute("UPDATE zadlist SET id = '"..cnt.."' WHERE uid = '"..row.uid.."'"))
                                row = cursor:fetch({}, "a")
                                cnt = cnt+1
                            end

                            sampAddChatMessage('Задание удалено',-1)
                        end
                    end

                    if button == 0 then
                        zadmenu()
                    end
                end

                -----------------------------------------------------------------------------------
                -- История выполнения заданий -----------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 4 then
                    local cursor = assert(conn:execute("SELECT * FROM history ORDER by uid ASC"))
                    local row = cursor:fetch({}, "a")
                    info = ''

                    while row do
                        info = '{87CEFA}'..row.datetime.. ' {FF8C00}' ..row.who_nick.. ' {87CEFA}выполнил задание: {FF8C00}'..row.zadanie..' {87CEFA}Причина: {FF8C00}'..row.reason..' {87CEFA}| {FF8C00}'..row.autor..' \n'..info
                        row = cursor:fetch({}, "a")
                    end

                    sampShowDialog(0, "{FFA500}История работы с заданиями", info, "Закрыть", "", DIALOG_STYLE_MSGBOX)
                    while sampIsDialogActive(0) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(0)

                    if button == 0 or button == 1 then
                        zadmenu()
                    end
                end
            end

            -----------------------------------------------------------------------------------
            -- Сервисные функции --------------------------------------------------------------
            -----------------------------------------------------------------------------------
            if button == 1 and list == 16 then
                zammenu_service()
                while sampIsDialogActive(9000) do wait(100) end
                local result, button, list, input = sampHasDialogRespond(9000)
                
                -----------------------------------------------------------------------------------
                -- Выполнить ручное обновление ----------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 0 then
                    sampAddChatMessage('Выполнена ручная проверка обновления', -255)
                    upd()
                end

                -----------------------------------------------------------------------------------
                -- Список изменений в версии ------------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 1 then
                    sampShowDialog(0, '{FFA500}Изменения в версии {7CFC00}'..thisScript().version, update_list, 'Закрыть', '', DIALOG_STYLE_MSGBOX)
                    while sampIsDialogActive(0) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(0)
                    if button == 0 then
                        zammenu_service()
                    end
                end

                -----------------------------------------------------------------------------------
                -- Режим AFK ----------------------------------------------------------------------
                -----------------------------------------------------------------------------------
                if button == 1 and list == 2 then
                    if afk then
                        afk = false
                        sampAddChatMessage('Режим AFK отключен.', -255)
                    else
                        afk = true
                        sampAddChatMessage('{90EE90}Включен режим AFK. Через 30 секунд ваша сессия будет завершена.', 0x90EE90)
                        sampAddChatMessage('{90EE90}За 5 минут до окончания рабочего дня будет выполнена команда /rec.', 0x90EE90)
                        sampAddChatMessage('{90EE90}После персонаж автоматически пойдет одеваться и встанет в угол фармить.', 0x90EE90)
                        sampAddChatMessage('{90EE90}Для отключения зайдите обратно в сервисное меню и переключите режим.', 0x90EE90)
                        lua_thread.create(function()
                            if afk then
                                sampAddChatMessage('{90EE90}До ухода в режим AFK осталось: {FFFFFF}30 секунд', 0x90EE90)
                                wait(1000*15)
                            end
                            if afk then                                
                                sampAddChatMessage('{90EE90}До ухода в режим AFK осталось: {FFFFFF}15 секунд', 0x90EE90)
                                wait(1000*5)
                            end
                            if afk then
                                sampAddChatMessage('{90EE90}До ухода в режим AFK осталось: {FFFFFF}10 секунд', 0x90EE90)
                                wait(1000*5)
                            end
                            if afk then
                                sampAddChatMessage('{90EE90}До ухода в режим AFK осталось: {FFFFFF}5 секунд', 0x90EE90)
                                wait(1000)
                            end
                            if afk then
                                sampAddChatMessage('{90EE90}До ухода в режим AFK осталось: {FFFFFF}4 секунды', 0x90EE90)
                                wait(1000)
                            end
                            if afk then
                                sampAddChatMessage('{90EE90}До ухода в режим AFK осталось: {FFFFFF}3 секунды', 0x90EE90)
                                wait(1000)
                            end
                            if afk then
                                sampAddChatMessage('{90EE90}До ухода в режим AFK осталось: {FFFFFF}2 секунды', 0x90EE90)
                                wait(1000)
                            end
                            if afk then
                                sampAddChatMessage('{90EE90}До ухода в режим AFK осталось: {FFFFFF}1 секунда', 0x90EE90)
                                wait(1000)
                            end
                            if afk then
                                sampAddChatMessage('{90EE90}Уходим в режим AFK до окончания рабочего дня.', 0x90EE90)
                                wait(1000)
                                sampSetGamestate(GAMESTATE_DISCONNECTED)
                                sampDisconnectWithReason(0)
                                sampAddChatMessage('', 0x90EE90)
                                sampAddChatMessage('{90EE90}Выполнен уход в режим АФК.', 0x90EE90)
                                sampAddChatMessage('{90EE90}Ожидаем {FFFFFF}19:55:00 {90EE90}для выхода из режима.', 0x90EE90)
                                sampAddChatMessage('', 0x90EE90)
                            end
                        end)
                    end
                    zammenu_service()
                end

                if button == 0 then
                    zammenu()
                end
            end

            if button == 0 then
                sampCloseCurrentDialogWithButton(0)
            end
        end

        if os.date('%M:%S') == "05:00" or os.date('%M:%S') == "15:00" or os.date('%M:%S') == "25:00" or os.date('%M:%S') == "35:00" or os.date('%M:%S') == "45:00" or os.date('%M:%S') == "55:00" then
            upd()
            wait(1000)
        end
    end
end

-- function JSONSave()
--     if doesFileExist("moonloader/firedep_zam_helper/data.json") then
--         local f = io.open("moonloader/firedep_zam_helper/data.json", 'w+')
--         if f then
--             f:write(encodeJson(config)):close()
--         end
--     end
-- end

function zammenu_service()
    
    if afk then
        afk_info = '{00FF7F}[Включен]'
    else
        afk_info = '{FFA07A}[Выключен]'
    end

    sampShowDialog(9000, "Сервисное меню", "Проверить наличие обновления вручную\nСписок изменений в обновлении {7CFC00}"..thisScript().version.."\n{FFFFFF}Режим AFK до конца РД "..afk_info, 'Выбрать', 'Назад', 2)
end

function zammenu()
    sampShowDialog(1999, "{FFA500}Меню заместителя начальника пожарного департамента", 'Работа с составом\nПроверить работу сотрудника\nРП отыгровки (лекции / тренировки / уведомления)\n \nРуссифицировать ник в буфер\nСкопировать ник для проверки ЧСП и ЧСГос\nПроверка на НонРП ник\nТаймеры\n \n{e9dc7c}Заказать доставку ТС\nНазначить собес на ближ. время\nУстановить отдел игроку\n{00EAFF}Сообщение в диалог ВК\n{00EAFF}Сообщение в диалог рук-ва ВК\n \nСовместные задания\nСервисное меню', 'Выбрать', 'Отмена', 2)
end

function zad()
    sampShowDialog(1001, "Добавить задание в очередь", "Выдать похвалу\nПовысить сотрудника\nПринять в организацию\nУстановить отдел\nВыдать выговор\nУволить из организации\nЗанести в ЧС орг", 'Выбрать', 'Отмена', 2)
end

function zadmenu()
    sampShowDialog(1000, "{FFA500}Меню заданий руководителей", 'Добавить задание\nСписок заданий на выполнение\nУдалить задание\n \nИстория выполнений', 'Выбрать', 'Отмена', 2)
end

function zad()
    sampShowDialog(9997, "Добавить задание в очередь", "Выдать похвалу\nВыдать повышение\nУстановить отдел\nПринять в организацию по заявлению", 'Выбрать', 'Отмена', 2)
end

function addzad(logo,data)
    sampShowDialog(9998, logo, data, 'Выбрать', 'Отмена', 1)
end

function zadlist(logo,data)
    sampShowDialog(9999, logo, data, 'Выбрать', 'Отмена', 2)
end

function sostav()
    sampShowDialog(2000, "{FFA500}Работа с составом", string.format("{7ce9b1}Принять в организацию\n{7ce9b1}Повысить сотрудника\n{7ce9b1}Снять выговор\nВыдать выговор\nВыдать выговор {f18779}(офлайн)\nУволить из организации\nУволить из организации {f18779}(офлайн)\nВыдать заглушку чата\nВнести в черный список\nВнести в черный список {f18779}(офлайн)\nПонизить сотрудника\n{dd3366}Выдать похвалу игроку\nВынести из черного списка\nВынести из черного списка {f18779}(офлайн)"), "Выбрать", "Отмена", 2)
end

function inputid()
    sampShowDialog(2001, "{FFA500}Id игрока для взаимодействия", "Введите id игрока", "Ввести", "Отмена", 1)
end

function invitereason()
    sampShowDialog(2002, "{FFA500}Тип вступелния в организацию", string.format("[1] Вступление по собеседованию\n[4] Вступление через заявки\n \n[1] По собеседованию сотрудником"), "Выбрать", "Отмена", 2)
end

function inputurl()
    sampShowDialog(2003, "{FFA500}Ссылка на отчет", "Введите ссылку на отчет игрока", "Ввести", "Отмена", 1)
end

function waitrp(id, nick)
    sampShowDialog(2004, "{FFA500}Подтверждение RP", "{78dbe2}После того, как игрок {ffa000}"..nick.." ["..id.."]\n{78dbe2}вступит в организацию, нажмите продолжить чтобы завершить РП отыгровку", "Продолжить", "Отмена", DIALOG_STYLE_MSGBOX)
end

function inputreason()
    sampShowDialog(2005, "{FFA500}Указание причины:", "Введите причину:", "Ввести", "Отмена", 1)
end

function lec()
    sampShowDialog(2006, "{FFA500}Лекции для состава пожарного департамента", string.format("[RB] Памятка для всех\n[R] Лекция про сон в раздевалке\n[D] Информация для департамента\n[Лекция] Алгоритм действий пожарных при пожаре в здании\nПровести инспекцию дому\n \nРП задания для сотрудников"), "Выбрать", "Отмена", 2)
end

function ranklist()
    sampShowDialog(2007, "{FFA500}Повышение", string.format("[1] Рекрут\n[2] Старший Рекрут\n[3] Младший пожарный\n[4] Пожарный\n[5] Старший пожарный\n[6] Пожарный инспектор\n[7] Лейтенант\n[8] Капитан"), "Выбрать", "Отмена", 2)
end

function inputnick()
    sampShowDialog(2008, "{FFA500}Ник игрока для взаимодействия", "Введите Nick_Name игрока", "Ввести", "Отмена", 1)
end

function rp()
    sampShowDialog(2009, "{FFA500}РП задания для сотрудников", "Помыть полы в холле департамента\nПолить цветы в холле департамента\nПроверить состояние огнетушителя в холле департамента\nЗаправить все свободные пожарные машины водой\nУтилизировать старые личные дела в архиве\nПротереть доску почета от пыли\nВыбросить муссор из раздевалки пожарного департамента", "Выбрать", "Отмена", 2)
end

function inputimer()
    sampShowDialog(2010, "{FFA500}Время установки таймера", "Введите колиство минут для таймера", "Ввести", "Отмена", 1)
end

function praisecount()
    sampShowDialog(2011, "{FFA500}Выдать похвалу игроку", "Введите колиство похвал дял игрока", "Ввести", "Отмена", 1)
end

function reason_mute()
    sampShowDialog(2012, "{FFA500}Причина выдачи заглушки", string.format("Села батарейка в рации\nОскорбление коллег\n \nВвести вручную"), "Выбрать", "Отмена", 2)
end

function reason_fwarn()
    sampShowDialog(2013, "{FFA500}Причина выговора", string.format("Нарушение устава\nПрогул рабочего дня\nСон на посту\nОтсутствие активности\n \nВвести вручную"), "Выбрать", "Отмена", 2)
end

function reason_univite()
    sampShowDialog(2014, "{FFA500}Причина увольнения", string.format("[ПСЖ] По собственному желанию\n[ГНУ] Грубое нарушение устава\nНеактив больше недели\n\nВвести вручную"), "Выбрать", "Отмена", 2)
end

function reason_blacklist()
    sampShowDialog(2015, "{FFA500}Причина ЧС организации", string.format("[ГНУ] Грубое нарушение устава\nУволен до 5ого ранга\nУволен с выговором\n\nВвести вручную"), "Выбрать", "Отмена", 2)
end

function inputidorg()
    sampShowDialog(2016, "{FFA500}Id сотрудника", "Введите id сотрудника, проводившего собеседование", "Ввести", "Отмена", 1)
end

function timermenu()
    sampShowDialog(2017, "{FFA500}Меню запуска таймера", "{E9967A}[5 мин] Таймер 5 минут для явки на работу\n[1 мин] Таймер на 1 минуту\n[3 мин] Таймер на 3 минуты\n[5 мин] Таймер на 5 минут\n{6B8E23}[Своё время] {FFFFFF}Установить таймер для игрока\n{6B8E23}[Своё время] {FFFFFF}Установить таймер для себя\n{0ec9d4}[15 мин] {8df2f7}Начать собеседование", "Ввести", "Отмена", 2)
end

function idhouse()
    sampShowDialog(2018, "{FFA500}Id дома", "Введите id дома для инспекции", "Ввести", "Отмена", 1)
end

function ocenka()
    sampShowDialog(2019, "{FFA500}Оценка инспекции дома", "Введите оценку дому за инспекцию:", "Ввести", "Отмена", 1)
end

function settag()
    sampShowDialog(2020, "{FFA500}Установить отдел игроку", "[TD] Tactical Department\n[ID] Inspection Department\n[DA] Department of Assistance\n[НонРП ник] Сменить ник", "Ввести", "Отмена", 2)
end

function inputdocs()
    sampShowDialog(2021, "{FFA500}Ссылка на доказательсвта", "Введите ссылку на доказательства нарушения: ", "Ввести", "Отмена", 1)
end

function inputmsg()
    sampShowDialog(2022, "{00EAFF}Отправить сообщение ВК", "Введите сообщение для отправки: ", "Отправить", "Отмена", 1)
end

function trst(name)
if name:match('%a+') then
        for k, v in pairs(trstl1) do
            name = name:gsub(k, v) 
        end
        for k, v in pairs(trstl) do
            name = name:gsub(k, v) 
        end
        return name
    end
 return name
end

local code_check = 'код для увольнения'
local nick = ''
local id = ''

function sampev.onServerMessage(color, text)
    if text:find('(.+)Список не доступен пока Вы не на смене/дежурстве(.+)') then
        lua_thread.create(function()
            wait(1000)
            runToJob()
            wait(3000)
            runToCorner()
            afk = false
        end)
    end

    if text:find('(.+)Заместитель начальника Irin_Crown(.+)назначил собеседование в свою организацию') then
        local time_sobes = text:match('на (%A+)!')
        id = sampGetPlayerIdByNickname('Irin_Crown')
        img = 'photo-232454643_456239042'
        sendvkimg(encodeUrl('Назначено собеседование на '..time_sobes.. '\n\nСобеседование продлится 15 минут. У Вас есть возможность приссоединиться и сформировать отчет, необходимый для повышения или получения похвалы.\n\nСобеседование назначил: Irin_Crown ['..id..']'),img)
    end

    if text:find('(%W)R(%W)(.+)(%a+)_(%a+)(.+)псж(.+)') then
        lua_thread.create(function()
            code_check = math.random(100000,999999)
            nick = string.match(text,"%a+_%a+")
            id = sampGetPlayerIdByNickname(nick)
            local nm = trst(nick)
            wait(1000)
            sampProcessChatInput('/rb Сотрудник '..nm..", отправьте в /r код - "..code_check, -1)
            wait(1000)
            sampProcessChatInput('/rb После отправки кода в /r, вы будете автоматически уволены.', -1)
        end)
    end

    if text:find('(%W)R(%W)(.+)(%a+)_(%a+)(.+)ПСЖ(.+)') then
        lua_thread.create(function()
            code_check = math.random(100000,999999)
            nick = string.match(text,"%a+_%a+")
            id = sampGetPlayerIdByNickname(nick)
            local nm = trst(nick)
            wait(1000)
            sampProcessChatInput('/rb Сотрудник '..nm..", отправьте в /r код - "..code_check, -1)
            wait(1000)
            sampProcessChatInput('/rb После отправки кода в /r, вы будете автоматически уволены.', -1)
        end)
    end

    if text:find('(%W)R(%W)(.+)(%a+)_(%a+)(.+)Псж(.+)') then
        lua_thread.create(function()
            code_check = math.random(100000,999999)
            nick = string.match(text,"%a+_%a+")
            id = sampGetPlayerIdByNickname(nick)
            local nm = trst(nick)
            wait(1000)
            sampProcessChatInput('/rb Сотрудник '..nm..", отправьте в /r код - "..code_check, -1)
            wait(1000)
            sampProcessChatInput('/rb После отправки кода в /r, вы будете автоматически уволены.', -1)
        end)
    end

    if text:find('Удачно') then
        lua_thread.create(function()
            inspect = 1
        end)
    end

    if text:find('Неудачно') then
        lua_thread.create(function()
            inspect = 0
        end)
    end

    if text:find('!end') then
        lua_thread.create(function()
            sampProcessChatInput('/do Собеседование окончено.',-1)
            wait(2000)
            sampProcessChatInput('/time',-1)
            sampShowDialog(0, "Собеседование окончено", "{78dbe2}Время проведения собеседования {FFA500}окончено.", "Уведомить", "Закрыть", DIALOG_STYLE_MSGBOX)
            img = 'photo-232454643_456239044'
            sendvkimg(encodeUrl('Собеседование окончено.'),img)
        end)
    end

    if text:find('прибыть в Пожарный департамент') then
        lua_thread.create(function()
            wait(1000)
            sampProcessChatInput('/do Собеседование начато.',-1)
            wait(1000)
            local timer = 15
            local time                          = os.date('%H:%M:%S', os.time() - (UTC * 3600))
            local timeend = os.date('%H:%M:%S', os.time() - (UTC * 3600)+(60*timer))
            img = 'photo-232454643_456239043'
            sendvkimg(encodeUrl('Собеседование начато и продлится 15 минут.'),img)
            sampAddChatMessage('{FFFFFF}Начато собеседование. Время собеседования {FFA500}'..timer..' минут',-1)
            sampAddChatMessage('{FFFFFF}Запушен в {FFA500}'..time,-1)
            sampAddChatMessage('{FFFFFF}Время окончания: {FFA500}'..timeend,-1)
            sampProcessChatInput('/time',-1)
            sampShowDialog(0, "Начало собеседования", "{78dbe2}Собеседование начато в {FFA500}"..time.."\n\n{78dbe2}Время собеседоваиня: {FFA500}"..timer.." {78dbe2}мин.\nВремя окончания: {FFA500}"..timeend, "Закрыть", "", DIALOG_STYLE_MSGBOX)
            wait(1000*60*timer)
            sampProcessChatInput('/do Собеседование окончено.',-1)
            wait(2000)
            sampProcessChatInput('/time',-1)
            sampShowDialog(0, "Собеседование окончено", "{78dbe2}Время проведения собеседования {FFA500}окончено.", "Уведомить", "Закрыть", DIALOG_STYLE_MSGBOX)
            
            while sampIsDialogActive(0) do wait(100) end
            local result, button, _, input = sampHasDialogRespond(0)
            if button == 1 then
                img = 'photo-232454643_456239044'
               sendvkimg(encodeUrl('Время проведения собеседования окончено.'),img)
            end
        end)
    end

    if text:find('(%W)R(%W)(.+)(%a+)_(%a+)(.+)увал(.+)') then
        lua_thread.create(function()
            code_check = math.random(100000,999999)
            nick = string.match(text,"%a+_%a+")
            id = sampGetPlayerIdByNickname(nick)
            local nm = trst(nick)
            wait(1000)
            sampProcessChatInput('/rb Сотрудник '..nm..", отправьте в /r код - "..code_check, -1)
            wait(1000)
            sampProcessChatInput('/rb После отправки кода в /r, вы будете автоматически уволены.', -1)
        end)
    end

    if text:find('(%W)R(%W)(.+)(%a+)_(%a+)(.+)Увал(.+)') then
        lua_thread.create(function()
            code_check = math.random(100000,999999)
            nick = string.match(text,"%a+_%a+")
            id = sampGetPlayerIdByNickname(nick)
            local nm = trst(nick)
            wait(1000)
            sampProcessChatInput('/rb Сотрудник '..nm..", отправьте в /r код - "..code_check, -1)
            wait(1000)
            sampProcessChatInput('/rb После отправки кода в /r, вы будете автоматически уволены.', -1)
        end)
    end

    if text:find('(%W)R(%W)(.+)(%a+)_(%a+)(.+):(%s)'..code_check) and string.match(text,"%a+_%a+") == nick then
        lua_thread.create(function()
            nick = string.match(text,"%a+_%a+")
            id = sampGetPlayerIdByNickname(nick)

            local time = os.date('%H:%M:%S', os.time() - (UTC * 3600))
            local timed = os.date('%H-%M-%S', os.time() - (UTC * 3600))
            local nm = trst(nick)

            wait(1000)
            sampProcessChatInput('/r Сотрудник '..nm..' решил покинуть нас. Благодарим за службу!', -1)
            wait(1000)
            sampProcessChatInput('/do КПК весит на поясе.', -1)
            wait(1000)
            sampProcessChatInput('/me сняла КПК с пояса и включила его', -1)
            wait(1000)
            sampProcessChatInput('/do КПК включен.', -1)
            wait(1000)
            sampProcessChatInput('/me зашла в базу данных сотрудников', -1)
            wait(1000)
            sampProcessChatInput('/me нашла нужного сотрудника и удалила из базы данных', -1)
            wait(1000)
            sampProcessChatInput('/me посмотрела очет по проделанной работе '..nm, -1)
            wait(1000)
            sampProcessChatInput('/time', -1)
            wait(2000)
            sampProcessChatInput('/checkjobprogress '..id, -1)
            wait(2000)
            sampProcessChatInput('/me выключила КПК и повесила на пояс', -1)
            wait(1000)
            sampProcessChatInput('/do КПК весит на поясе.', -1)
            wait(1000)
            sampProcessChatInput('/me заблокировала канал радиостанции сотруднику '..nm, -1)
            wait(1000)
            sampProcessChatInput('/uninvite '..id..' ПСЖ', -1)
            wait(2000)
            sampProcessChatInput('/r Сотрудник '..nm..' был уволен из организации по причине: ПCЖ (Автомат).',-1)
            wait(1000)
            sampProcessChatInput('/time ',-1)
            sampShowDialog(0, "{FFA500}Увольнение сотрудника", "{78dbe2}Сотрудник: {ffa000}"..nick.." ["..id.."]\n\n{78dbe2}Дата увольнения: {ffa000}"..date.."\n{78dbe2}Время увольнения: {ffa000}"..time.."\n\n{78dbe2}Причина увольнения: {ffa000}ПСЖ (автомат)", "Закрыть", "", DIALOG_STYLE_MSGBOX)

            
            lfs.mkdir('moonloader/firedep_zam_helper/Отчеты о проделанной работе/Наказания/'..date.. ' ' ..timed.. ' ' ..nick.. ' (uninvite-auto)')
            file = io.open("moonloader/firedep_zam_helper/history.txt", "a")
            file:write('[Автоматическое увольнение сотрудника из организации]. Сотрудник: '..nick.. ' ['..id..'] Дата увольнения: '..date..' Время увольнения: '..time..' Причина: ПСЖ-автоматически\n') --буфер откуда будет записывать инфу
            file:close()

            info = ('Автоматическое увольнение ПСЖ. \n\nСотрудник: '..nick.. ' ['..id..'] \nДата увольнения: '..date..' \nВремя увольнения: '..time..'\nПричина: ПСЖ (Автоматически).\nКод для увольнения: '..code_check)
            sendvkimg(encodeUrl(info),img)
        end)
    end
end

function sampGetPlayerIdByNickname(nick)
    local _, myid = sampGetPlayerIdByCharHandle(playerPed)
    if tostring(nick) == sampGetPlayerNickname(myid) then return myid end
    for i = 0, 1000 do if sampIsPlayerConnected(i) and sampGetPlayerNickname(i) == tostring(nick) then return i end end
        return -1
end

function sampev.onShowDialog(id, style, title, button1, button2, text)
    if start_sobes then
        if id == 1214 then
            sampSendDialogResponse(1214, 1, 7, nil)
            sampSendDialogResponse(1336, 1, 0, nil)
            sampSendDialogResponse(1335, 1 , nil, sobes)
            return false
        end
        start_sobes = false
    end

    if afk and id == 25527 then
        if title:find("Выбор места спавна") then 
            if text:find("Последнее место выхода") then 
                sampSendDialogResponse(id, 1, 4, nil)
                sampAddChatMessage('{90EE90}Событие с последним местом выхода', -1)
                sampProcessChatInput('/fires',-1)
                sampProcessChatInput('/fires',-1)
                return false
            end
            sampSendDialogResponse(id, 1, 3, nil)
            sampAddChatMessage('{90EE90}Событие обычное', -1)
            sampProcessChatInput('/fires',-1)
            sampProcessChatInput('/fires',-1)
            return false
        end
    end

    if afk and id == 27263 then
        if title:find("Раздевалка") then
            changedesk = false
            sampSendDialogResponse(id, 1, 0, nil)
            return false -- Убираем рисовку окон
        end
    end
end

-- local dialog_id = 32 --айди диалога
-- local send_text = 'Можно ли проводить собеседование не в рд?' --текст который будет отправлен в качестве ответа на диалог
-- function sampev.onShowDialog(id, style, title, button1, button2, text)
--     if id == dialog_id then
--         sampSendDialogResponse(dialog_id, 1 , nil, send_text)
--         return false
--     end
-- end

function encodeUrl(str)
   str = str:gsub(' ', '%+')
   str = str:gsub('\n', '%%0A')
   return u8:encode(str, 'CP1251')
end

function threadHandle(runner, url, args, resolve, reject) -- обработка effil потока без блокировок
    local t = runner(url, args)
    local r = t:get(0)
    while not r do
        r = t:get(0)
        wait(0)
    end
    local status = t:status()
    if status == 'completed' then
        local ok, result = r[1], r[2]
        --if ok then resolve(result) else reject(result) end
    elseif err then
        reject(err)
    elseif status == 'canceled' then
        reject(status)
    end
    t:cancel(0)
end

function requestRunner() -- создание effil потока с функцией https запроса
    return effil.thread(function(u, a)
        local https = require 'ssl.https'
        local ok, result = pcall(https.request, u, a)
        if ok then
            return {true, result}
        else
            return {false, result}
        end
    end)
end

function async_http_request(url, args, resolve, reject)
    local runner = requestRunner()
    if not reject then reject = function() end end
    lua_thread.create(function()
        threadHandle(runner, url, args, resolve, reject)
    end)
end

local vkerr, vkerrsend -- сообщение с текстом ошибки, nil если все ок

function loop_async_http_request(url, args, reject)
    local runner = requestRunner()
    if not reject then reject = function() end end
    lua_thread.create(function()
        while true do
            while not key do wait(0) end
            url = server .. '?act=a_check&key=' .. key .. '&ts=' .. ts .. '&wait=25' --меняем url каждый новый запрос потокa, так как server/key/ts могут изменяться
            threadHandle(runner, url, args, longpollResolve, reject)
        end
    end)
end
function sendvkmsg(msg)
    local rnd = math.random(-2147483648, 2147483647)
    local peer_id = 2000000003
    local token2 = 'vk1.a.5MHxEjL9XhlKr4tWm_zjzke1IM86jlBC3UrZdFGQbHAD05Xteuc2cohwaUKQN3wcw8bgXJRm1o7tGc0u2qVUbVZPbAdIQaRoCp1gmQIf0Z8d3FX_3iZswg7qF8mcAWIlTrgHr5D9xtPUaTw5h3CAyxT8Dqcs20_z1lXiUCtSLHa4-teHPO7rozXirKy_B6gnBMAAqFunjb5k_R5ai60Xmg'
    local test = 'photo-232454643_456239019'
    async_http_request('https://api.vk.com/method/messages.send', 'peer_id='..peer_id..'&random_id=' .. rnd .. '&message='..msg..'&access_token='..token2..'&v=5.81')
end

function sendvkmsgtest(msg,img)
    local rnd = math.random(-2147483648, 2147483647)
    local peer_id = 2000000003
    local token2 = 'vk1.a.5MHxEjL9XhlKr4tWm_zjzke1IM86jlBC3UrZdFGQbHAD05Xteuc2cohwaUKQN3wcw8bgXJRm1o7tGc0u2qVUbVZPbAdIQaRoCp1gmQIf0Z8d3FX_3iZswg7qF8mcAWIlTrgHr5D9xtPUaTw5h3CAyxT8Dqcs20_z1lXiUCtSLHa4-teHPO7rozXirKy_B6gnBMAAqFunjb5k_R5ai60Xmg'
    local test = 'photo-232454643_456239019'
    async_http_request('https://api.vk.com/method/messages.send', 'peer_id='..peer_id..'&random_id=' .. rnd .. '&message='..msg..'&attachment='..img..'&access_token='..token2..'&v=5.81')
end

function sendvkimg(msg,img)
    local rnd = math.random(-2147483648, 2147483647)
    local peer_id = 2000000002
    local token2 = 'vk1.a.5MHxEjL9XhlKr4tWm_zjzke1IM86jlBC3UrZdFGQbHAD05Xteuc2cohwaUKQN3wcw8bgXJRm1o7tGc0u2qVUbVZPbAdIQaRoCp1gmQIf0Z8d3FX_3iZswg7qF8mcAWIlTrgHr5D9xtPUaTw5h3CAyxT8Dqcs20_z1lXiUCtSLHa4-teHPO7rozXirKy_B6gnBMAAqFunjb5k_R5ai60Xmg'
    local test = 'photo-232454643_456239019'
    async_http_request('https://api.vk.com/method/messages.send', 'peer_id='..peer_id..'&random_id=' .. rnd .. '&message='..msg..'&attachment='..img..'&access_token='..token2..'&v=5.81')
end
function sendvkimg_test(msg,img)
    local rnd = math.random(-2147483648, 2147483647)
    local peer_id = 2000000001
    local token2 = 'vk1.a.5MHxEjL9XhlKr4tWm_zjzke1IM86jlBC3UrZdFGQbHAD05Xteuc2cohwaUKQN3wcw8bgXJRm1o7tGc0u2qVUbVZPbAdIQaRoCp1gmQIf0Z8d3FX_3iZswg7qF8mcAWIlTrgHr5D9xtPUaTw5h3CAyxT8Dqcs20_z1lXiUCtSLHa4-teHPO7rozXirKy_B6gnBMAAqFunjb5k_R5ai60Xmg'
    local test = 'photo-232454643_456239019'
    async_http_request('https://api.vk.com/method/messages.send', 'peer_id='..peer_id..'&random_id=' .. rnd .. '&message='..msg..'&attachment='..img..'&access_token='..token2..'&v=5.81')
end

function vkmsg(msg)
    local rnd = math.random(-2147483648, 2147483647)
    local peer_id = 2000000002
    -- local peer_id = 2000000001
    local token2 = 'vk1.a.5MHxEjL9XhlKr4tWm_zjzke1IM86jlBC3UrZdFGQbHAD05Xteuc2cohwaUKQN3wcw8bgXJRm1o7tGc0u2qVUbVZPbAdIQaRoCp1gmQIf0Z8d3FX_3iZswg7qF8mcAWIlTrgHr5D9xtPUaTw5h3CAyxT8Dqcs20_z1lXiUCtSLHa4-teHPO7rozXirKy_B6gnBMAAqFunjb5k_R5ai60Xmg'
    async_http_request('https://api.vk.com/method/messages.send', 'peer_id='..peer_id..'&random_id=' .. rnd .. '&message='..msg..'&access_token='..token2..'&v=5.81')
end

function upd()
   local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=0x40E0D0;
                                                           sampAddChatMessage(b..'Обнаружено обновление. {FA8072}'..thisScript().version..' {40E0D0}на {7CFC00}'..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('Загружено %d из %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then 
                                                                                                                   sampShowDialog(0, "{FFA500}Вышло обновление", "{FFA500}Помощник руководителя пожарного департамента\n{78dbe2}был автоматически обновлен на новую версию.\nПосмотреть изменения можно в Меню -> Сервисные функции -> Изменения", "Закрыть", "", DIALOG_STYLE_MSGBOX)
                                                           print('Загрузка обновления завершена.')sampAddChatMessage(b..'Обновление завершено!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'Обновление прошло неудачно. Запускаю устаревшую версию..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': Обновление не требуется.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, выходим из ожидания проверки обновления. Смиритесь или проверьте самостоятельно на '..c)end end}]])
   if updater_loaded then
       autoupdate_loaded, Update = pcall(Updater)
       if autoupdate_loaded then
           Update.json_url = "https://raw.githubusercontent.com/ArtemyevaIA/firedep_zam_helper/refs/heads/main/firedep_zam_helper.json?" .. tostring(os.clock())
           Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
           Update.url = "https://github.com/ArtemyevaIA/firedep_zam_helper"
       end

   end
   if autoupdate_loaded and Update then
       pcall(Update.check, Update.json_url, Update.prefix, Update.url)
   end 
end

-- Пойти встать в угол
function runToCorner(tox, toy)
    local tox = -1282.1599
    local toy = -45.0525
    local x, y, z = getCharCoordinates(PLAYER_PED)
    local angle = getHeadingFromVector2d(tox - x, toy - y)
    local xAngle = math.random(-50, 50)/100
    setCameraPositionUnfixed(xAngle, math.rad(angle - 90))
    while getDistanceBetweenCoords2d(x, y, tox, toy) > 0.8 do
        setGameKeyState(1, -255)
        setGameKeyState(16, 1)
        wait(1)
        x, y, z = getCharCoordinates(PLAYER_PED)
        angle = getHeadingFromVector2d(tox - x, toy - y)
        setCameraPositionUnfixed(xAngle, math.rad(angle - 90))
    end
end

-- Пойти переодеться в форму
function runToJob(tox, toy)
    local tox, toy = -1290.1544, -48.5959
    local x, y, z = getCharCoordinates(PLAYER_PED)
    local angle = getHeadingFromVector2d(tox - x, toy - y)
    local xAngle = math.random(-50, 50)/100
    setCameraPositionUnfixed(xAngle, math.rad(angle - 90))
    while getDistanceBetweenCoords2d(x, y, tox, toy) > 0.8 do
        setGameKeyState(1, -255)
        setGameKeyState(16, 1)
        wait(1)
        x, y, z = getCharCoordinates(PLAYER_PED)
        angle = getHeadingFromVector2d(tox - x, toy - y)
        setCameraPositionUnfixed(xAngle, math.rad(angle - 90))
    end

    local tox, toy = -1289.7994, -45.7143
    local x, y, z = getCharCoordinates(PLAYER_PED)
    local angle = getHeadingFromVector2d(tox - x, toy - y)
    local xAngle = math.random(-50, 50)/100
    setCameraPositionUnfixed(xAngle, math.rad(angle - 90))
    while getDistanceBetweenCoords2d(x, y, tox, toy) > 0.8 do
        setGameKeyState(1, -255)
        setGameKeyState(16, 1)
        wait(1)
        x, y, z = getCharCoordinates(PLAYER_PED)
        angle = getHeadingFromVector2d(tox - x, toy - y)
        setCameraPositionUnfixed(xAngle, math.rad(angle - 90))
    end

    local tox, toy = -1288.4854, -45.5982
    local x, y, z = getCharCoordinates(PLAYER_PED)
    local angle = getHeadingFromVector2d(tox - x, toy - y)
    local xAngle = math.random(-50, 50)/100
    setCameraPositionUnfixed(xAngle, math.rad(angle - 90))
    while getDistanceBetweenCoords2d(x, y, tox, toy) > 0.8 do
        setGameKeyState(1, -255)
        setGameKeyState(16, 1)
        wait(1)
        x, y, z = getCharCoordinates(PLAYER_PED)
        angle = getHeadingFromVector2d(tox - x, toy - y)
        setCameraPositionUnfixed(xAngle, math.rad(angle - 90))
    end
end

function getpoyas()
    timepc = os.date('%H:%M:%S')
    timeserver = os.date('%H:%M:%S', os.time() - (UTC * 3600))
    info = os.date("%z",os.time()) .. "\t" ..os.offset()
    info = info:gsub('0', '')
    info = info:gsub('+', '')
    sampAddChatMessage('Часовой пояс: {FFFFFF}+'..UTC, -255)
    sampAddChatMessage('Время на ПК: {FFFFFF}'..timepc, -255)
    sampAddChatMessage('Время на сервере: {FFFFFF}'..timeserver, -255)
    sampAddChatMessage('Мой часовой пояс: {FFFFFF}'..info, -255)
    return info
end

function os.offset()
   local currenttime = os.time()
   local datetime = os.date("*t",currenttime)
   datetime.isdst = true -- Флаг дневного времени суток
   return currenttime - os.time(datetime)
end
---@class NUI
local NUI = _G.unpack(_G.ElvUI_NihilistzscheUI)

local NI = NUI.Installer

local wipe = _G.wipe

function NI.DetailsSetup()
    -- luacheck: push no max line length
    local nihilistzscheui_skin =
        "XjFeVF5TaGlkZV9pbl9jb21iYXRfdHlwZV5OMV5TbWVudV9pY29uc19zaXplXkY3NjU2MTE5NTgxMjc4MjA5XmYtNTNeU2NvbG9yXlReTjFeRjYwMDQ3OTk1MDMxNjA2NTVeZi01NF5OMl5GNjAwNDc5OTUwMzE2MDY1NV5mLTU0Xk4zXkY2MDA0Nzk5NTAzMTYwNjU1XmYtNTReTjReTjAuMzc3Nzc3Nzc3Nzc3N150XlNtZW51X2FuY2hvcl5UXk4xXk4xNl5OMl5OMF5Tc2lkZV5OMl50XlNiZ19yXk4wXlNoaWRlX291dF9vZl9jb21iYXReYl5TZm9sbG93aW5nXlReU2VuYWJsZWReYl5TYmFyX2NvbG9yXlReTjFeTjFeTjJeTjFeTjNeTjFedF5TdGV4dF9jb2xvcl5UXk4xXk4xXk4yXk4xXk4zXk4xXnRedF5TY29sb3JfYnV0dG9uc15UXk4xXk4xXk4yXk4xXk4zXk4xXk40Xk4xXnReU3N3aXRjaF9oZWFsZXJeYl5TbWljcm9fZGlzcGxheXNfbG9ja2VkXkJeU2JhcnNfZ3Jvd19kaXJlY3Rpb25eTjFeU3RvdGFsX2Jhcl5UXlNlbmFibGVkXmJeU29ubHlfaW5fZ3JvdXBeQl5TaWNvbl5TSW50ZXJmYWNlXElDT05TXElOVl9TaWdpbF9UaG9yaW1eU2NvbG9yXlReTjFeTjFeTjJeTjFeTjNeTjFedF50XlNzaG93X3NpZGViYXJzXkJeU3Rvb2x0aXBeVF5Tbl9hYmlsaXRpZXNeTjNeU25fZW5lbWllc15OM150XlNsaWJ3aW5kb3deVF5TeV5GNzMxODM2NjU3NDM0NjI0MF5mLTQ4XlN4XkYtNjA1MTcxNjI5NDI0NjQwMF5mLTQ1XlNwb2ludF5TQk9UVE9NUklHSFRedF5Td2luZG93X3NjYWxlXk4xXlNzd2l0Y2hfYWxsX3JvbGVzX2luX2NvbWJhdF5iXlNpbnN0YW5jZV9idXR0b25fYW5jaG9yXlReTjFeTi0yN15OMl5OMV50XlN2ZXJzaW9uXk4zXlNhdHRyaWJ1dGVfdGV4dF5UXlNlbmFibGVkXkJeU3NoYWRvd15iXlNzaWRlXk4xXlN0ZXh0X2NvbG9yXlReTjFeTjFeTjJeTjFeTjNeTjFeTjReTjFedF5TY3VzdG9tX3RleHReU3tuYW1lfV5TdGV4dF9mYWNlXlNTa3VsbH5gYW5kfmBWb2lkXlNhbmNob3JeVF5OMV5OLTE4Xk4yXk4zXnReU3RleHRfc2l6ZV5OMTJeU2VuYWJsZV9jdXN0b21fdGV4dF5iXlNzaG93X3RpbWVyXlReTjFeQl5OMl5CXk4zXkJedF50XlNzaG93X3N0YXR1c2Jhcl5iXlNtZW51X2FscGhhXlReU2VuYWJsZWReYl5Tb25sZWF2ZV5OMV5TaWdub3JlYmFyc15iXlNpY29uc3Rvb15CXlNvbmVudGVyXk4xXnReU3N3aXRjaF9kYW1hZ2VyX2luX2NvbWJhdF5iXlNtZW51X2FuY2hvcl9kb3duXlReTjFeTjE2Xk4yXk4tM150XlNzdGF0dXNiYXJfaW5mb15UXlNhbHBoYV5OMC4zNzc3Nzc3Nzc3Nzc3XlNvdmVybGF5XlReTjFeRjYwMDQ3OTk1MDMxNjA2NTVeZi01NF5OMl5GNjAwNDc5OTUwMzE2MDY1NV5mLTU0Xk4zXkY2MDA0Nzk5NTAzMTYwNjU1XmYtNTRedF50XlNzdHJhdGFeU0xPV15TYXV0b19oaWRlX21lbnVeVF5TbGVmdF5iXlNyaWdodF5iXnReU3N3aXRjaF9kYW1hZ2VyXmJeU2lnbm9yZV9tYXNzX3Nob3doaWRlXmJeU2hpZGVfaW5fY29tYmF0X2FscGhhXk4wXlNwbHVnaW5zX2dyb3dfZGlyZWN0aW9uXk4xXlNtZW51X2ljb25zXlReTjFeQl5OMl5CXk4zXkJeTjReQl5ONV5CXk42XmJeU3NwYWNlXk4tMl5Tc2hhZG93XmJedF5TZGVzYXR1cmF0ZWRfbWVudV5iXlNtaWNyb19kaXNwbGF5c19zaWRlXk4yXlNzd2l0Y2hfYWxsX3JvbGVzX2FmdGVyX3dpcGVeYl5Tcm93X3Nob3dfYW5pbWF0aW9uXlReU2FuaW1eU0ZhZGVeU29wdGlvbnNeVF50XnReU3N3aXRjaF90YW5rXmJeU2JnX2FscGhhXk4xXlNzd2l0Y2hfdGFua19pbl9jb21iYXReYl5TZ3JhYl9vbl90b3BeYl5TYmFyc19zb3J0X2RpcmVjdGlvbl5OMV5Tc2tpbl5TTWluaW1hbGlzdGljXlNhdXRvX2N1cnJlbnReQl5TdG9vbGJhcl9zaWRlXk4xXlNiZ19nXk4wXlNzd2l0Y2hfaGVhbGVyX2luX2NvbWJhdF5iXlNoaWRlX2luX2NvbWJhdF5iXlNiYXJzX2ludmVydGVkXmJeU3NraW5fY3VzdG9tXlNeU2JhY2tkcm9wX3RleHR1cmVeU0RldGFpbHN-YEdyb3VuZF5Td2FsbHBhcGVyXlReU292ZXJsYXleVF5OMV5OMV5OMl5OMV5OM15OMV5ONF5OMV50XlN3aWR0aF5GNDk3ODU5MTg3MTc5NTIwNF5mLTQ0XlN0ZXhjb29yZF5UXk4xXk4wXk4yXk4xXk4zXk4wXk40Xk4wLjdedF5TZW5hYmxlZF5CXlNhbmNob3JeU2FsbF5TaGVpZ2h0XkY4MDI1MDI4ODE3ODQ2Mjk2XmYtNDZeU2FscGhhXk4wLjVeU3RleHR1cmVeU0ludGVyZmFjZVxBZGRPbnNcRGV0YWlsc1xpbWFnZXNcYmFja2dyb3VuZF50XlNzdHJldGNoX2J1dHRvbl9zaWRlXk4xXlNoaWRlX2ljb25eQl5Tcm93X2luZm9eVF5TdGV4dFJfb3V0bGluZV5iXlNzcGVjX2ZpbGVeU0ludGVyZmFjZVxBZGRPbnNcRGV0YWlsc1xpbWFnZXNcc3BlY19pY29uc19ub3JtYWxeU3RleHRMX291dGxpbmVeYl5TdGV4dHVyZV9oaWdobGlnaHReU0ludGVyZmFjZVxGcmllbmRzRnJhbWVcVUktRnJpZW5kc0xpc3QtSGlnaGxpZ2h0XlN0ZXh0TF9vdXRsaW5lX3NtYWxsXkJeU3BlcmNlbnRfdHlwZV5OMV5TZml4ZWRfdGV4dF9jb2xvcl5UXk4xXk4xXk4yXk4xXk4zXk4xXnReU3NwYWNlXlReU3JpZ2h0Xk4wXlNsZWZ0Xk4wXlNiZXR3ZWVuXk4wXnReU3RleHR1cmVfYmFja2dyb3VuZF9jbGFzc19jb2xvcl5iXlN0ZXh0TF9vdXRsaW5lX3NtYWxsX2NvbG9yXlReTjFeTjBeTjJeTjBeTjNeTjBeTjReTjFedF5TZm9udF9mYWNlX2ZpbGVeU0ludGVyZmFjZVxBZGRPbnNcRWx2VUlfQ2hhb3RpY1VJXG1lZGlhXGZvbnRzXFNrdWxsLWFuZC1Wb2lkLnR0Zl5TdGV4dExfY3VzdG9tX3RleHReU3tkYXRhMX0ufmB7ZGF0YTN9e2RhdGEyfV5TbW9kZWxzXlReU3VwcGVyX21vZGVsXlNTcGVsbHNcQWNpZEJyZWF0aF9TdXBlckdyZWVuLk0yXlNsb3dlcl9tb2RlbF5TV29ybGRcRVhQQU5TSU9OMDJcRE9PREFEU1xDb2xkYXJyYVxDT0xEQVJSQUxPQ1VTLm0yXlN1cHBlcl9hbHBoYV5OMC41XlNsb3dlcl9lbmFibGVkXmJeU2xvd2VyX2FscGhhXk4wLjFeU3VwcGVyX2VuYWJsZWReYl50XlNoZWlnaHReTjE0XlN0ZXh0dXJlX2ZpbGVeU0ludGVyZmFjZVxBZGRPbnNcRWx2VUlfQ2hhb3RpY1VJXG1lZGlhXHRleHR1cmVzXHNpbXB5X3RleDE0XlN0ZXh0dXJlX2N1c3RvbV9maWxlXlNJbnRlcmZhY2VcXlNpY29uX2ZpbGVeU0ludGVyZmFjZVxBZGRPbnNcRGV0YWlsc1xpbWFnZXNcY2xhc3Nlc19zbWFsbF9hbHBoYV5TaWNvbl9ncmF5c2NhbGVeYl5TdGV4dHVyZV9iYWNrZ3JvdW5kX2ZpbGVeU0ludGVyZmFjZVxBZGRPbnNcRWx2VUlfQ2hhb3RpY1VJXG1lZGlhXHRleHR1cmVzXHNpbXB5X3RleDVeU3RleHRSX2JyYWNrZXReUyheU3RleHRSX2VuYWJsZV9jdXN0b21fdGV4dF5iXlNmb250X3NpemVeTjEwXlNmaXhlZF90ZXh0dXJlX2NvbG9yXlReTjFeTjBeTjJeTjBeTjNeTjBedF5TdGV4dExfc2hvd19udW1iZXJeQl5TYmFja2Ryb3BeVF5TZW5hYmxlZF5iXlNzaXplXk4xMl5TY29sb3JeVF5OMV5OMV5OMl5OMV5OM15OMV5ONF5OMV50XlN0ZXh0dXJlXlNEZXRhaWxzfmBCYXJCb3JkZXJ-YDJedF5TdGV4dHVyZV9jdXN0b21eU15TdGV4dFJfY3VzdG9tX3RleHReU3tkYXRhMX1-YCh7ZGF0YTJ9LH5ge2RhdGEzfSUpXlN0ZXh0dXJlXlNTaW1weX5gRHJ5fmBTd2lybF5TdGV4dFJfb3V0bGluZV9zbWFsbF5CXlNmaXhlZF90ZXh0dXJlX2JhY2tncm91bmRfY29sb3JeVF5OMV5OMF5OMl5OMF5OM15OMF5ONF5GNTQxMjU1NTM2NzM4MzAzNl5mLTU1XnReU3RleHRSX2NsYXNzX2NvbG9yc15iXlN0ZXh0TF9jbGFzc19jb2xvcnNeYl5TdGV4dFJfb3V0bGluZV9zbWFsbF9jb2xvcl5UXk4xXk4wXk4yXk4wXk4zXk4wXk40Xk4xXnReU3RleHR1cmVfYmFja2dyb3VuZF5TU2ltcHl-YENyYXRlcl5TYWxwaGFeTjFeU25vX2ljb25eYl5TdGV4dFJfc2hvd19kYXRhXlReTjFeQl5OMl5CXk4zXkJedF5TdGV4dExfZW5hYmxlX2N1c3RvbV90ZXh0XmJeU2ZvbnRfZmFjZV5TU2t1bGx-YGFuZH5gVm9pZF5TdGV4dHVyZV9jbGFzc19jb2xvcnNeQl5Tc3RhcnRfYWZ0ZXJfaWNvbl5CXlNmYXN0X3BzX3VwZGF0ZV5iXlN0ZXh0Ul9zZXBhcmF0b3JeUyxeU3VzZV9zcGVjX2ljb25zXkJedF5TbmFtZV5TQ2hhb3RpY1VJXlNiZ19iXk4wXnReXg=="
    -- luacheck: pop
    local _detalhes = _G._detalhes

    wipe(_detalhes.savedStyles)

    local doimport = function(text)
        local decode = _detalhes._encode:Decode(text)
        if type(decode) ~= "string" then return end

        local unserialize = select(2, _detalhes:Deserialize(decode))

        if type(unserialize) == "table" then
            if unserialize[1] and unserialize[2] and unserialize[3] and unserialize[4] and unserialize[5] then
                local register = _detalhes:TimeDataRegister(unpack(unserialize))
                if type(register) == "string" then _detalhes:Msg(register) end
            end
        end
    end

    doimport(nihilistzscheui_skin)

    local Loc = _G.LibStub("AceLocale-3.0"):GetLocale("Details")

    local onSelectCustomSkin = function(_, _, index)
        local style

        if type(index) == "table" then
            style = index
        else
            style = _detalhes.savedStyles[index]
            if not style.version or _detalhes.preset_version > style.version then
                return _detalhes:Msg(Loc.STRING_OPTIONS_PRESETTOOLD)
            end
        end

        --> set skin preset
        local skin = style.skin
        _G.DetailsOptionsWindow.instance.skin = ""
        _G.DetailsOptionsWindow.instance:ChangeSkin(skin)

        --> overwrite all instance parameters with saved ones
        for key, value in pairs(style) do
            if key ~= "skin" and not _detalhes.instance_skin_ignored_values[key] then
                if type(value) == "table" then
                    _G.DetailsOptionsWindow.instance[key] = _G.table_deepcopy(value)
                else
                    _G.DetailsOptionsWindow.instance[key] = value
                end
            end
        end

        --> apply all changed attributes
        _G.DetailsOptionsWindow.instance:ChangeSkin()

        if _detalhes.options_group_edit and not _G.DetailsOptionsWindow.loading_settings then
            for _, this_instance in ipairs(_G.DetailsOptionsWindow.instance:GetInstanceGroup()) do
                if this_instance ~= _G.DetailsOptionsWindow.instance then
                    this_instance.skin = ""
                    this_instance:ChangeSkin(skin)

                    --> overwrite all instance parameters with saved ones
                    for key, value in pairs(style) do
                        if key ~= "skin" and not _detalhes.instance_skin_ignored_values[key] then
                            if type(value) == "table" then
                                this_instance[key] = _G.table_deepcopy(value)
                            else
                                this_instance[key] = value
                            end
                        end
                    end

                    this_instance:ChangeSkin()
                end
            end
        end

        _detalhes:SendOptionsModifiedEvent(_G.DetailsOptionsWindow.instance)

        --> reload options panel
        _detalhes:OpenOptionsWindow(_G.DetailsOptionsWindow.instance)

        _G.DetailsOptionsWindow3CustomSkinLoadDropdown.MyObject:Select(false)
        _G.DetailsOptionsWindow3CustomSkinLoadDropdown.MyObject:Refresh()

        _detalhes:Msg(Loc.STRING_OPTIONS_SKIN_LOADED)
    end

    local _

    local lower_instance = _detalhes:GetLowerInstanceNumber()
    if not lower_instance then
        --> no window opened?
        local instance1 = _detalhes.tabela_instancias[1]
        if instance1 then
            instance1:Enable()
            _detalhes:OpenOptionsWindow(instance1)
        else
            instance1 = _detalhes:CriarInstancia(_, true)
            if instance1 then
                _detalhes:OpenOptionsWindow(instance1)
            else
                _detalhes:Msg("couldn't open options panel: no window available.")
            end
        end
    else
        _detalhes:OpenOptionsWindow(_detalhes:GetInstance(lower_instance))
    end

    for index, savedStyle in ipairs(_detalhes.savedStyles) do
        if savedStyle.name == "NihilistzscheUI" then
            onSelectCustomSkin(_, _, index)
            break
        end
    end
end

NI:RegisterGlobalAddOnInstaller("Details", NI.DetailsSetup)

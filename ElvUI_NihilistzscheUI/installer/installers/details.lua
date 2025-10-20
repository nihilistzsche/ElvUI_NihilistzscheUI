---@class NUI
local NUI = _G.unpack((select(2, ...)))

local NI = NUI.Installer

local wipe = _G.wipe

function NI.DetailsSetup()
    -- luacheck: push no max line length
    local nihilistzscheui_skin =
        [[TIvBVTnos4FnhWEaBmKKF)JXnnDdqQ9IQ0BVpyigkjABIqtjqsh30dn)2VziPEnoz1bClWMAjroC4mpZZ8qMeM8qsS(qXzI2qnN0PuvsAs8UcPrBuC5EnXW(HzmHkZouOswpErsSHBemyKeCIsC8hzYtvd5HK1HjRJcG)pzDayDEod)TjjoDpbmrWOOjJH14KqKwOYzGD4)KHVFAs8by0KItgsXoswXXuQbTFwHOqrspzmfsTFfcTla83X2)ob)lSgMIcb6B8ScjzhxWsIVtAyQD0m22RZZ3i1BVHzOCHEl)iDptVT9u0KiyBrZlodUlvPj6cLHKZvSmdVqIls8jnJqpzkiubFVKC8KWWjTczjRsIvfNPkgTAdwfO0N5MSdWefevHGPjCz7TPGN9K5GQ40(deVxzDQ38rW82xwNkWS0jfSz97TxFmMPysU5LKyWjlumYrQwB9emgFPSmrWpYXi)onZKS(Qqi7zdJ5mnaouudlV1MiNIHplEXHGaZIHm8fN5YC8vzuibGXmQbwiibYCjgFg3NVXxz3n(eHdYe2bJyHa(uFf2ct9bnPElk0LePIYduesTmYc7sTWUPlwGz1SNYvfLxiK9fi4kZ9WTQ1Auy445UfCuyWYfUvDuyu40z21gwKPZToGd8IzujACNfGcmMKMkCXoU8zMsBd)ptfNWTzqamxW(dCGJh6aNm0boDOdC2qh48HoWfdDGlh6abq7qh5GZnHdo5eo4St4GtpHdn)aiq9tCzs8x5sGAtW1gEwpIdxHPR6xikGh3JwhR6AJ67sUA6S8wQIpAWDlf)qZ6PsoWaEIl25jQUZZ8XDmBvpJfqb(rEMQaiP1Lc6lAsvhNyWqm08Ughn0kLIt75Gn2d0O942X3WL7kQ7lcS4sQLSUMMsxYYgyRf7qDomWbd5ex47ESfNGlT5qCjDCUyRnGeS0YmQ47pyS)sW25(rAbSpoI)04SZ3QSdrd2wGnE6y(MxxYuzmPHyEP0tTY)blN83MlRSNVNqGp9)sVxa8OeKyDVLbLKjWEno7MErFAi85iwGGb33ly)zXZF)UTFcAUT9RSCoD7Ti6z7N)rPIP1NPVmYy2b2HAZVnDE62I7aZfPJcBAoGjI3pS0i24nTqwrvRSnSE9XOovno8Ayu9gR(fXhlYzcBU)ujKNi2NtIHCMaqsxNXZxbsjmhiW3zQVOym5OVcZdkFBg9FvOe5B)8)(pVED8DBwheT9MnBU56BIH4JiNQu0TFAZ93C93(213V5tFpE0XOQ1RUz50kB2YVDVOEiHvtQzi1GKStAaEAXujX)NCQHg(RrV(O9xJ)L9FI(fwvsbjv0DqY0vsvJAnkQulajiwtK2aT8wUpmOzaFeaHSMFGJKH)uNDGbaMJwSIFQ6T3ZnmWqLJm7PEbpDajbv1Aw(aCx4afRqmXkesScJb2jcASEkjojUayObUOUO8rvYiM71qm3PFaNDpAMlatrvNn0jyq7)bjU2csqUPJpWnZ9kGS0kqlTAh6sQDsK1Flvb1gG3e)B9Zl4g2JaAQ7TYaBizSJ(Dl5RHq2qS80XuOBaSd9WUWlrYKexL4Q8WlH)E9XFZd8(9AK4)4F2QYTXi6si(HvHxI5LzodLDvetD2wT59(isTBNojmA60PJNnF8IXbJNLS7QPtr7vHwUGtDHf5)Fy9kJFa2Wc7MULzVvXzYC9Tk6r22VF3v(NVhm(v)rZe8H(2j(vxS50qy8Lf1nzTquFbq350V3hUE1TksIBy)BHt75Ewyw72cwBq1gsPMCQeGjTkk0SskC2hW3J)9kC6flum(JmA1N5pRuZ5E8NiOUNG1nOEXy1stSDxBAn0fslHuXV8EVHFe5LrAJQaUpaCDg0Xa61tfV(4FcHc8HSx6onbeEQtuKb0PRZH7dhnXokBZSgZI27YmiTw609o6YwNPKGY6CcBHEdsOFVxWwNf9QO5ExdbkqKijUhy3VoCecRovc7liJ64HADxdDVZclbtx51fsbJ(SlD4o6C1PATmVWHuXnAHKHRtxDSG3)u1bznCRkcyxKcoPHZ0ymfEMjzh9p1xbC3RdaKVInBIVFZF1tfpx6gf4QVGotpbWIcGP2IWWdkyL2oU6O2vlqDl9KyOrqkESvu5PvpkWYWqYmLSNwaEQ)8dWg7LKBNnD285aB20OO5ldMeaeAtGty)diznDuuue89iqtrzbKssIxT5Hh281VD3x(duBD1ndySccCx9uTY7A5gJN36)QjkDiIBNfemz(YLtdgholygqLc8PwG579LXV3xm9YHDZd2I6lCwH09n6IMTmiS)T(m0RSWbZj5iW0xGnZo8RAJq8x3sxxR)XLMuFCPG3KWRL(BV7QStkG7WyPH6FPuoTzN5Lwwq8mLT60d7692Btbs79xJ66kNgL3itc23RW7ByfExcPvTCHs7wCHM3C5zn3oO1ZTlPLY4bFh60QE22zFg2iLuqJA)662GNpqrFwbSUDsBHTsBOQTg(WyRCk)jiUDrq00GOflcNVyYSOLyd(jZqF8zqHoEG02kTpZZnhsUDYY5lMUmCX8W5lNgfmbNZe3fzcm4e8czFd90lyehvduwjdSDJ77(0M1XBVB9)Ia0xCb5bWr5h)OZZyH)1xLy15HaqO9SPUJbJ3OGf5JLNs0E3sHEwXfL4BXCT1kOk1lEHO9VPYEsJJ8sJJ8sJJ8b7fwZM8Fp]]
    -- luacheck: pop
    local Details = _G._detalhes

    wipe(Details.savedStyles)

    local doimport = function(text)
        local dataTable = Details:DecompressData(nihilistzscheui_skin, "print")

        if dataTable then Details.savedStyles[#Details.savedStyles + 1] = dataTable end
    end

    doimport(nihilistzscheui_skin)

    local loadSkin = function(instance, skinObject)
        function Details:LoadSkinFromOptionsPanel(skinObject)
            --set skin preset
            local instance = self
            local skin = skinObject.skin
            instance.skin = ""
            instance:ChangeSkin(skin)

            --overwrite all instance parameters with saved ones
            for key, value in pairs(skinObject) do
                if key ~= "skin" and not Details.instance_skin_ignored_values[key] then
                    if type(value) == "table" then
                        instance[key] = Details.CopyTable(value)
                    else
                        instance[key] = value
                    end
                end
            end

            --apply all changed attributes
            instance:ChangeSkin()
        end

        instance:LoadSkinFromOptionsPanel(skinObject)
    end

    for _, savedStyle in ipairs(Details.savedStyles) do
        if savedStyle.name == "NihilistzscheUI" then
            for _, instance in Details:ListInstances() do
                loadSkin(instance, savedStyle)
            end
            break
        end
    end
end

NI:RegisterGlobalAddOnInstaller("Details", NI.DetailsSetup)

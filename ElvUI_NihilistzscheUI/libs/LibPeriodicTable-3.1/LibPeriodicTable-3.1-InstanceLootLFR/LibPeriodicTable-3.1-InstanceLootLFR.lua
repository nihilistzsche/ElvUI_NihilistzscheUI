-- (c) 2007 Nymbia.  see LGPLv2.1.txt for full details.
--DO NOT MAKE CHANGES TO THIS FILE BEFORE READING THE WIKI PAGE REGARDING CHANGING THESE FILES
if not LibStub("LibPeriodicTable-3.1", true) then
    error("PT3 must be loaded before data")
end
LibStub("LibPeriodicTable-3.1"):AddData(
    "InstanceLootLFR",
    gsub(
        "$Rev: 402 $",
        "(%d+)",
        function(n)
            return n + 90000
        end
    ),
    {
        -- Dragon Soul
        ["InstanceLootLFR.Dragon Soul.Morchok"] = "77979:10,77980:13,77981:10,77982:12,77983:10,78375:195,78376:194,78377:180,78378:120,78380:112,78381:177,78382:225,78384:109,78385:105,78386:98,78494:10,78495:10,78496:11,78497:12,78498:12,78862:32,78863:25,78864:23,78865:30,78866:19,78867:23,78868:29,78869:26,78870:20,78871:29,78872:27,78873:23,78874:33,78875:27,78876:24",
        ["InstanceLootLFR.Dragon Soul.Warlord Zon'ozz"] = "77969:218,77979:9,77980:12,77981:10,77982:10,77983:12,78395:196,78396:187,78397:122,78398:148,78399:123,78400:92,78494:9,78495:11,78496:11,78497:10,78498:10,78862:3,78863:3,78864:3,78865:395,78866:310,78867:343,78868:3,78869:4,78870:3,78871:4,78872:3,78873:4,78874:5,78875:5,78876:3",
        ["InstanceLootLFR.Dragon Soul.Yor'sahj the Unsleeping"] = "77970:125,77971:200,77979:9,77980:9,77981:9,77982:8,77983:9,78408:138,78411:100,78412:95,78494:7,78495:8,78496:8,78497:10,78498:9,78862:40,78863:35,78864:28,78865:37,78866:26,78867:30,78868:39,78869:30,78870:28,78871:414,78872:365,78873:320,78874:44,78875:33,78876:30",
        ["InstanceLootLFR.Dragon Soul.Hagara the Stormbinder"] = "77979:10,77980:8,77981:6,77982:8,77983:8,78421:174,78422:119,78423:141,78424:122,78425:149,78427:185,78428:87,78494:6,78495:7,78496:8,78497:10,78498:9,78862:12,78863:9,78864:8,78865:10,78866:9,78867:10,78868:11,78869:10,78870:6,78871:11,78872:9,78873:8,78874:394,78875:345,78876:303",
        ["InstanceLootLFR.Dragon Soul.Lesser Cache of the Aspects"] = "77972:244,77979:15,77980:20,77981:13,77982:5,77983:20,78438:86,78439:112,78440:212,78441:162,78442:188,78443:186,78444:183,78494:18,78495:7,78496:20,78497:2,78498:13,78862:490,78863:482,78864:412,78865:36,78866:2,78867:2,78868:13,78869:2,78870:2,78871:2,78872:13,78873:2,78874:23,78875:7,78876:10",
        ["InstanceLootLFR.Dragon Soul.Ultraxion"] = "m,InstanceLootLFR.Dragon Soul.Lesser Cache of the Aspects",
        ["InstanceLootLFR.Dragon Soul.Warmaster Blackhorn"] = "77973:166,77979:6,77980:6,77981:6,77982:6,77983:5,78454:119,78455:104,78456:98,78457:109,78458:98,78460:105,78494:6,78495:5,78496:6,78497:5,78498:7,78862:23,78863:21,78864:16,78865:21,78866:14,78867:16,78868:373,78869:323,78870:293,78871:23,78872:17,78873:15,78874:24,78875:20,78876:17",
        ["InstanceLootLFR.Dragon Soul.Greater Cache of the Aspects"] = "77974:295,77975:278,77976:204,77977:292,77978:210,78466:308,78467:306,78468:201,78469:210,78470:263",
        ["InstanceLootLFR.Dragon Soul.Spine of Deathwing"] = "m,InstanceLootLFR.Dragon Soul.Greater Cache of the Aspects",
        ["InstanceLootLFR.Dragon Soul.Elementium Fragment"] = "78480:168,78481:216,78482:203,78483:175,78484:249,78485:239,78486:137,78487:245,78488:168",
        ["InstanceLootLFR.Dragon Soul.Madness of Deathwing"] = "m,InstanceLootLFR.Dragon Soul.Elementium Fragment",
        -- Terrace of Endless Spring (Raid)
        ["InstanceLootLFR.Terrace of Endless Spring.Protectors of the Endless"] = "m,InstanceLootLFR.Terrace of Endless Spring.Protector Kaolan,InstanceLootLFR.Terrace of Endless Spring.Elder Asani,InstanceLootLFR.Terrace of Endless Spring.Elder Regail",
        ["InstanceLootLFR.Terrace of Endless Spring.Protector Kaolan"] = "86868:0,86869:0,86870:0,86871:0,86872:0,86873:0,86874:0,86875:0,86876:0,86877:0,86878:0,86909:0",
        ["InstanceLootLFR.Terrace of Endless Spring.Elder Asani"] = "86868:0,86869:0,86870:0,86871:0,86872:0,86873:0,86874:0,86875:0,86876:0,86877:0,86878:0,86909:0",
        ["InstanceLootLFR.Terrace of Endless Spring.Elder Regail"] = "86868:0,86869:0,86870:0,86871:0,86872:0,86873:0,86874:0,86875:0,86876:0,86877:0,86878:0,86909:0",
        ["InstanceLootLFR.Terrace of Endless Spring.Tsulong"] = "86879:0,86880:0,86881:0,86882:0,86883:0,86884:0,86885:0,86886:0,86887:0,86888:0,86895:0,86896:0,86897:0,86898:0,86899:0,86900:0,86901:0,86902:0,86903:0,86904:0,89980:0,89981:0,89982:0,89983:0",
        ["InstanceLootLFR.Terrace of Endless Spring.Lei Shi"] = "86889:0,86890:0,86891:0,86892:0,86893:0,86894:0,86895:0,86896:0,86897:0,86898:0,86899:0,86900:0,86901:0,86902:0,86903:0,86904:0,86910:0,89276:0,89277:0,89278:0",
        ["InstanceLootLFR.Terrace of Endless Spring.Sha of Fear"] = "86905:3,86906:3,86907:3,86908:3,87210:1000,89273:3,89274:3,89275:3,89984:3,89985:3,89986:3",
        -- Heart of Fear (Raid)
        ["InstanceLootLFR.Heart of Fear.Imperial Vizier Zor'lok"] = "86811:0,86812:0,86813:0,86814:0,86815:0,86816:0,86817:0,86818:0,86819:0,86854:0,87823:0,89952:0,89953:0,89954:0",
        ["InstanceLootLFR.Heart of Fear.Blade Lord Ta'yak"] = "86820:0,86821:0,86822:0,86823:0,86824:0,86825:0,86826:0,86827:0,86828:0,86829:0,89955:0,89956:0,89957:0,90739:0",
        ["InstanceLootLFR.Heart of Fear.Garalon"] = "86830:0,86831:0,86832:0,86833:0,86834:0,86835:0,86836:0,86837:0,86838:0,86839:0,86840:0,89958:0,89959:0,89960:0",
        ["InstanceLootLFR.Heart of Fear.Wind Lord Mel'jarak"] = "86851:0,86852:0,86853:0,86855:0,86856:0,86911:0,86912:0,89270:0,89271:0,89272:0",
        ["InstanceLootLFR.Heart of Fear.Amber-Shaper Un'sok"] = "86857:0,86858:0,86859:0,86860:0,86861:0,86862:0,86863:0,89267:0,89268:0,89269:0",
        ["InstanceLootLFR.Heart of Fear.Grand Empress Shek'zeer"] = "86864:0,86865:0,86866:0,86867:0,89264:0,89265:0,89266:0,89961:0,89962:0,89963:0",
        -- Mogu'shan Vaults (Raid)
        ["InstanceLootLFR.Mogu'shan Vaults.The Stone Guard"] = "m,InstanceLootLFR.Mogu'shan Vaults.Amethyst Guardian,InstanceLootLFR.Mogu'shan Vaults.Cobalt Guardian,InstanceLootLFR.Mogu'shan Vaults.Jade Guardian,InstanceLootLFR.Mogu'shan Vaults.Jasper Guardian",
        ["InstanceLootLFR.Mogu'shan Vaults.Amethyst Guardian"] = "86739:0,86740:0,86741:0,86742:0,86743:0,86744:0,86745:0,86746:0,86747:0,86748:0,86793:0,89964:0,89965:0,89966:0",
        ["InstanceLootLFR.Mogu'shan Vaults.Cobalt Guardian"] = "86739:0,86740:0,86741:0,86742:0,86743:0,86744:0,86745:0,86746:0,86747:0,86748:0,86793:0,89964:0,89965:0,89966:0",
        ["InstanceLootLFR.Mogu'shan Vaults.Jade Guardian"] = "86739:0,86740:0,86741:0,86742:0,86743:0,86744:0,86745:0,86746:0,86747:0,86748:0,86793:0,89964:0,89965:0,89966:0",
        ["InstanceLootLFR.Mogu'shan Vaults.Jasper Guardian"] = "86739:0,86740:0,86741:0,86742:0,86743:0,86744:0,86745:0,86746:0,86747:0,86748:0,86793:0,89964:0,89965:0,89966:0",
        ["InstanceLootLFR.Mogu'shan Vaults.Feng the Accursed"] = "86749:0,86750:0,86751:0,86752:0,86753:0,86754:0,86755:0,86756:0,86757:0,86758:0,86782:0,89426:0,89967:0,89968:0",
        ["InstanceLootLFR.Mogu'shan Vaults.Gara'jal the Spiritbinder"] = "86759:0,86760:0,86761:0,86762:0,86763:0,86764:0,86765:0,86766:0,86767:0,86768:0,86769:0,86770:0,89969:0",
        ["InstanceLootLFR.Mogu'shan Vaults.The Spirit Kings"] = "m,InstanceLootLFR.Mogu'shan Vaults.Zian of the Endless Shadow,InstanceLootLFR.Mogu'shan Vaults.Meng the Demented,InstanceLootLFR.Mogu'shan Vaults.Qiang the Merciless,InstanceLootLFR.Mogu'shan Vaults.Subetai the Swift",
        ["InstanceLootLFR.Mogu'shan Vaults.Zian of the Endless Shadow"] = "86776:0,86777:0,86778:0,86779:0,86780:0,86781:0,86782:0,86783:0,86784:0,86785:0,86786:0,86787:0,86788:0,89970:0,89971:0",
        ["InstanceLootLFR.Mogu'shan Vaults.Meng the Demented"] = "86776:0,86777:0,86778:0,86779:0,86780:0,86781:0,86782:0,86783:0,86784:0,86785:0,86786:0,86787:0,86788:0,89970:0,89971:0",
        ["InstanceLootLFR.Mogu'shan Vaults.Qiang the Merciless"] = "86776:0,86777:0,86778:0,86779:0,86780:0,86781:0,86782:0,86783:0,86784:0,86785:0,86786:0,86787:0,86788:0,89970:0,89971:0",
        ["InstanceLootLFR.Mogu'shan Vaults.Subetai the Swift"] = "86776:0,86777:0,86778:0,86779:0,86780:0,86781:0,86782:0,86783:0,86784:0,86785:0,86786:0,86787:0,86788:0,89970:0,89971:0",
        ["InstanceLootLFR.Mogu'shan Vaults.Elegon"] = "86789:0,86790:0,86791:0,86792:0,86794:0,86795:0,86796:0,86797:0,86798:0,86799:0,86800:0,89972:0,89973:0,89974:0",
        ["InstanceLootLFR.Mogu'shan Vaults.Will of the Emperor"] = "m,InstanceLootLFR.Mogu'shan Vaults.Jan-xi,InstanceLootLFR.Mogu'shan Vaults.Qin-xi",
        ["InstanceLootLFR.Mogu'shan Vaults.Jan-xi"] = "",
        ["InstanceLootLFR.Mogu'shan Vaults.Qin-xi"] = "86801:0,86802:0,86803:0,86804:0,86805:0,86806:0,86807:0,86808:0,86809:0,86810:0,87826:0,89975:0,89976:0,89977:0"
    }
)

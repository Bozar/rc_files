;Last Update: Jun 05, Fri | 13:32:38 | 2015
capslock::ctrl
#q::!F4
#PgUp::
Send {Volume_Up}
return
#PgDn::
Send {Volume_Down}
return
#End::
Send {Volume_Mute}
return
F12::
IfWinActive, MINGW32
{
    MouseMove, 50, 50
    Send {RButton}
}
else
{
    Send {F12}
}

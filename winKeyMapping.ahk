;Last Update: Jun 03, Wed | 13:44:30 | 2015
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
#F12::
IfWinActive, MINGW32
{
    MouseMove, 50, 50
    Send {RButton}
    return
}

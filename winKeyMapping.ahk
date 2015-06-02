;Last Update: Jun 02, Tue | 13:21:11 | 2015
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
    MouseMove, 600, 300
    Send {RButton}
}
return

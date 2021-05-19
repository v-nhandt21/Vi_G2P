# Building a Vietnamese lexicon for the input words
# This is a verry first and simple version. It can work on multiwords such as "xin_chao",...
# Author: Nguyen Van Huy, huynguyen@tnut.edu.vn
# 2014-Step-12
# syntax:
# tclsh #me wordlist
# The lexicon will be created and pasted in the standard output. The non-vietnamese words will be moved to notVI.txt file
#!/bin/tclsh
encoding system utf-8
# vietnmaese triphone and tiphone
if { $argc != 1 } {
	puts "Requite an input Word-List"
	exit 0
}

#load middel phone
set lcuda "oai oao oay uây oeo iêu yêu uya uyu uôi ươi ươu uyê oài oào oày uầy oèo iều yều uỳa uỳu uồi ười ườu uyề oái oáo oáy uấy oéo iếu yếu uýa uýu uối ưới ướu uyế oải oảo oảy uẩy oẻo iểu yểu uỷa uỷu uổi ưởi ưởu uyể oãi oão oãy uẫy oẽo iễu yễu uỹa uỹu uỗi ưỡi ưỡu uyễ oại oạo oạy uậy oẹo iệu yệu uỵa uỵu uội ượi ượu uyệ ưa ươ ai ay ây oi ôi ơi ưi ao au âu eo êu ưu oa oa oă oe oe yê oo ôô uâ uê uô uơ uy uy ua ui ia iê iu ừa ườ ài ày ầy òi ồi ời ừi ào àu ầu èo ều ừu oà òa oằ oè òe yề oò ôồ uầ uề uồ uờ ùy uỳ ùa ùi ìa iề ìu ứa ướ ái áy ấy ói ối ới ứi áo áu ấu éo ếu ứu oá óa oắ oé óe yế oó ôố uấ uế uố uớ úy uý úa úi ía iế íu ửa ưở ải ảy ẩy ỏi ổi ởi ửi ảo ảu ẩu ẻo ểu ửu oả ỏa oẳ oẻ ỏe yể oỏ ôổ uẩ uể uổ uở ủy uỷ ủa ủi ỉa iể ỉu ữa ưỡ ãi ãy ẫy õi ỗi ỡi ữi ão ãu ẫu ẽo ễu ữu oã õa oẵ oẽ õe yễ oõ oỗ uẫ uễ uỗ ưõ ũy uỹ ũa ũi ĩa iễ ĩu ựa ượ ại ạy ậy ọi ội ợi ựi ạo ạu ậu ẹo ệu ựu oạ ọa oặ oẹ ọe yệ oọ oộ uậ uệ uộ uợ ụy uỵ ụa ụi ịa iệ ịu à ằ ầ è ề ì ò ồ ờ ừ ỳ ù á ắ ấ é ế í ó ố ớ ứ ý ú ả ẳ ẩ ẻ ể ỉ ỏ ổ ở ử ỷ ủ ã ẵ ẫ ẽ ễ ĩ õ ỗ ỡ ữ ỹ ũ ạ ặ ậ ẹ ệ ị ọ ộ ợ ự ỵ ụ a ă â e ê i o ô ơ ư y u"
# Load Begining phoneme
set Bphonemef [open "BphonemeVN.txt" r]
set LBphoneme [split [read $Bphonemef] "\n"]
close $Bphonemef
# Load Ending phoneme
set Ephonemef [open "EphonemeVN.txt" r]
set LEphoneme [split [read $Ephonemef] "\n"]
close $Ephonemef
# Load Middle phoneme
set Mphonemef [open "MphonemeVN.txt" r]
set LMphoneme [split [read $Mphonemef] "\n"]
close $Mphonemef
####
# input word list to make phoneme Dict
set inf [open [lindex $argv 0] r]
set errf [open notVI.txt w]
#================================ 
set allwlist [split [read $inf ] "\n"]
set mwlist [lsearch -inline -all $allwlist "*_*"]
set wlist [lsearch -inline -all -not $allwlist "*_*"]
#######################################
close $inf
set count [expr -1]
set wdone ""
######## for normal word
foreach phone $lcuda {
	incr count
	#puts "working on phone: $phone"
	set outsearch [lsearch -inline -all $wlist "*$phone*"]
	if {$outsearch!=-1} {
		foreach word $outsearch {
			if {$count < 78 } {
				set Mphone [lindex $lcuda [expr $count % 13]]
				set toneP [expr $count/13]
			} elseif {$count > 77 && $count < 282} {
				set Mphone [lindex $lcuda [expr (($count-78) % 34)+78]]
				set toneP [expr  ($count-78)/34]
			} else {
				set Mphone [lindex $lcuda [expr (($count-282) % 12)+342]]
				set toneP [expr  ($count-282)/12]
				if {$toneP<5} {set toneP [expr $toneP+1]} else {set toneP 0}
			}
			switch $toneP {
                        	0 {set tone 1}
                                1 {set tone 2}
                                2 {set tone 3}
                                3 {set tone 4}
                                4 {set tone 5}
                                5 {set tone 6}
                        }			
			set start [string first $phone $word]
			set end [expr $start + [string length $phone] -1]
			if {$start!=0} {
				set Bphone [string range $word 0 [expr $start-1]]
			} else {
				set Bphone ""
			}
			if {$end!=[expr [string length $word]-1]} {
				set Ephone [string range $word [expr $end+1] end]
			} else {
				set Ephone ""
			}
			if {$Bphone=="q" && [string index $Mphone 0]=="u" && [string length $Mphone]>1} {
				set Bphone "qu"
				set Mphone [string range $Mphone 1 end]
			}
			if {$Bphone=="g" && [string index $Mphone 0]=="i" && [string length $Mphone]>1} {
                                set Bphone "gi"
                                set Mphone [string range $Mphone 1 end]
                        }
			# convert phone to phoneme
			if {$Bphone=="qu"} {
				set Bphoneme "k w"
				set doneB "1"
			} elseif {$Bphone!=""} {
				set Bphoneme [lsearch -inline $LBphoneme "${Bphone}\ *"]
				set doneB "0"
			} else { 
				set Bphoneme " "
				set doneB "1" 
			}
			if {$Ephone!=""} { 
				set Ephoneme [lsearch -inline $LEphoneme "${Ephone}\ *"]
				set doneE "0"
			} else {
				set Ephoneme " "
				set doneE "1"
			}
			set Mphoneme [lsearch -inline $LMphoneme "${Mphone}\ *"]
			if {$Bphoneme=="" || $Ephoneme=="" || $Mphoneme==""} {
				# ERROR word or Foreign word
				puts $errf $word 
			} else {			
			   if {[llength $Mphoneme]>2} {
				set tmpstr ""
				set Mphoneme [lrange $Mphoneme 1 end]
				foreach ph $Mphoneme {
					if {$ph=="w"} {
						if {$Bphone!="qu"} {
							set tmpstr "$tmpstr ${ph}"
						}
					} else {
						set tmpstr "$tmpstr ${ph}${tone}"
					}
				}				
			    } else {
				set tmpstr "[lindex $Mphoneme 1]${tone}"
			    }
			    if {$doneB=="0"} { set Bphoneme [lindex $Bphoneme 1] }
                            if {$doneE=="0"} { set Ephoneme [lindex $Ephoneme 1] }
			    set tmpstr [string trim "$Bphoneme [string trim $tmpstr] $Ephoneme"]
			    lappend tmpdict "$word	$tmpstr"
			}
			set wlist [lsearch -inline -all -not -exact $wlist $word]
		}		
	}
	
}
set outdict [lsort $tmpdict]
foreach tmp $outdict {puts $tmp}
foreach tmp2 $wlist {puts $errf $tmp2}
unset wlist tmpdict
################
foreach mword $mwlist {
	set wlist [split $mword "_"]
	set count [expr -1]
	set wdone ""
	foreach phone $lcuda {
        	incr count
        	#puts "working on phone: $phone"
	        set outsearch [lsearch -inline -all $wlist "*$phone*"]
        	if {$outsearch!=-1} {
                	foreach word $outsearch {
                        	if {$count < 78 } {
                                	set Mphone [lindex $lcuda [expr $count % 13]]
	                                set toneP [expr $count/13]
        	                } elseif {$count > 77 && $count < 282} {
                	                set Mphone [lindex $lcuda [expr (($count-78) % 34)+78]]
                        	        set toneP [expr  ($count-78)/34]
	                        } else {
        	                        set Mphone [lindex $lcuda [expr (($count-282) % 12)+342]]
                	                set toneP [expr  ($count-282)/12]
                        	        if {$toneP<5} {set toneP [expr $toneP+1]} else {set toneP 0}
	                        }
        	                switch $toneP {
					0 {set tone 1}
                        	        1 {set tone 2}
                	                2 {set tone 3}
        	                        3 {set tone 4}
	                                4 {set tone 5}
				}
                	        set start [string first $phone $word]
        	                set end [expr $start + [string length $phone] -1]
	                        if {$start!=0} {
                                	set Bphone [string range $word 0 [expr $start-1]]
                        	} else {
                	                set Bphone ""
        	                }
	                        if {$end!=[expr [string length $word]-1]} {
                                	set Ephone [string range $word [expr $end+1] end]
                        	} else {
                	                set Ephone ""
        	                }
	                        if {$Bphone=="q" && [string index $Mphone 0]=="u" && [string length $Mphone]>1} {
                                	set Bphone "qu"
                        	        set Mphone [string range $Mphone 1 end]
                	        }
        	                if {$Bphone=="g" && [string index $Mphone 0]=="i" && [string length $Mphone]>1} {
	                                set Bphone "gi"
                                	set Mphone [string range $Mphone 1 end]
                        	}
                	        # convert phone to phoneme
        	                if {$Bphone=="qu"} {
	                                set Bphoneme "k w"
                                	set doneB "1"
                        	} elseif {$Bphone!=""} {
                	                set Bphoneme [lsearch -inline $LBphoneme "${Bphone}\ *"]
        	                        set doneB "0"
	                        } else {
	                                set Bphoneme " "
        	                        set doneB "1"
	                        }
                        	if {$Ephone!=""} {
                	                set Ephoneme [lsearch -inline $LEphoneme "${Ephone}\ *"]
        	                        set doneE "0"
	                        } else {
                        	        set Ephoneme " "
                	                set doneE "1"
        	                }
	                        set Mphoneme [lsearch -inline $LMphoneme "${Mphone}\ *"]
                        	if {$Bphoneme=="" || $Ephoneme=="" || $Mphoneme==""} {
                	                # ERROR word or Foreign word
        	                        puts $errf $word
	                        } else {
                        	   if {[llength $Mphoneme]>2} {
                	                set tmpstr ""
        	                        set Mphoneme [lrange $Mphoneme 1 end]
	                                foreach ph $Mphoneme {
                                	        if {$ph=="w"} {
                        	                        if {$Bphone!="qu"} {
                	                                        set tmpstr "$tmpstr ${ph}"
        	                                        }
	                                        } else {
                                        	        set tmpstr "$tmpstr ${ph}${tone}"
                                	        }
                        	        }
                	            } else {
        	                    	set tmpstr "[lindex $Mphoneme 1]${tone}"
	                            }
				    if {$doneB=="0"} { set Bphoneme [lindex $Bphoneme 1] }
                	            if {$doneE=="0"} { set Ephoneme [lindex $Ephoneme 1] }
        	                    set tmpstr [string trim "$Bphoneme [string trim $tmpstr] $Ephoneme"]
	                            lappend tmpdict "$word $tmpstr"
                        	}
                	        set wlist [lsearch -inline -all -not -exact $wlist $word]
        	        }
	        }
	}
	if {[llength $wlist]>0} { 
		puts $errf $mword
	} else {
		set tmstr $mword
		set tmstr2 ""
		foreach mw [split $mword "_"] {
			set out [lsearch -inline $tmpdict "$mw*"]
			set tmstr2 "$tmstr2 [string range $out [expr [string first " " $out] +1 ] end]"
		}
		puts "$tmstr	[string trim $tmstr2]"
		unset wlist tmpdict
	}
}
####################
close $errf

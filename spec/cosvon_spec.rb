require File.expand_path(File.dirname(__FILE__)+'/spec_helper')

cases=[
	[
		{
			"DreamCast"=>"SEGA",
			"HI-Saturn"=>"Hitachi",
			"FamiconTV"=>"Sharp",
		},<<-EOM
CoSVON:0.1
DreamCast,SEGA
HI-Saturn,Hitachi
FamiconTV,Sharp
		EOM
	],[
		{
			"foo"=>"bar",
		},<<-EOM
CoSVON:0.1
foo,bar
		EOM
	],[
		{
			"comma"=>"[,]",
			"dq"=>'["]',
			"n"=>"[\n]",
			"tab"=>"[\t]",
		},<<-EOM
CoSVON:0.1
comma,"[,]"
dq,"[""]"
n,"[
]"
tab,[	]
		EOM
	],[
		{
			"SH3"=>"Super Hitachi 3",
			"ATOK"=>"Awa TOKushima",
			"ICU" => "Isolated Crazy Utopia",
			"BING"=>"Bing Is Not Google",
		},<<-EOM
CoSVON:0.1
SH3,Super Hitachi 3
ATOK,Awa TOKushima
ICU,Isolated Crazy Utopia
BING,Bing Is Not Google
		EOM
	],[
		{
			"Google"=>"Chrome",
			"Apple"=>"Safari",
			"Opera"=>"Opera",
			"Mozilla"=>"Firefox"
		},<<-EOM
CoSVON:0.1,,,
Google,Chrome,,
Apple,Safari,"",
Opera,Opera,,""
Mozilla,Firefox,"",""
,,,
,,,
,,,
		EOM
	],[
		{
			"no DQ"=>"foo",
			"with DQ"=>"foo",
			"inner DQ"=>"foo\"bar",
			"many DQs"=>"\"\"\"\"\"\"\"\"\""
		},<<-EOM
CoSVON:0.1
no DQ,foo
with DQ,"foo"
inner DQ,"foo""bar"
many DQs,""""""""""""""""""""
		EOM
	],[
		{
			"no extra comma"=>"hoge",
			"extra comma"=>"fuga",
			"extra comma with DQ"=>"piyo",
			"many extra commas"=>"moge"
		},<<-EOM
CoSVON:0.1
no extra comma,hoge
extra comma,fuga,
extra comma with DQ,piyo,""
many extra commas,moge,,,,,,,
"",""
,,
,"",
		EOM
	]
]

describe "CoSVON [default]" do
	cases.each_with_index{|e,i|
		specify "Case #{i+1}" do
			hash=CoSVON.parse(e[1])
			cosvon=CoSVON.stringify(hash)
			CoSVON.parse(cosvon).should eq e[0]
		end
	}
end

describe "CoSVON [CoSVON.csv]" do
	cases.each_with_index{|e,i|
		specify "Case #{i+1}" do
			hash=CoSVON.parse(e[1],CoSVON.method(:csv))
			cosvon=CoSVON.stringify(hash)
			CoSVON.parse(cosvon,CoSVON.method(:csv)).should eq e[0]
		end
	}
end

require 'csv'
describe "CoSVON [CSV.parse]" do
	cases.each_with_index{|e,i|
		specify "Case #{i+1}" do
			hash=CoSVON.parse(e[1],CSV.method(:parse))
			cosvon=CoSVON.stringify(hash)
			CoSVON.parse(cosvon,CSV.method(:parse)).should eq e[0]
		end
	}
end

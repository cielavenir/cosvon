#coding:utf-8

# CoSVON: Comma Separated Value Object Notation (yokohamarb)
#
# http://nabetani.sakura.ne.jp/yokohamarb/2014.01.cosvon/

class CoSVON
	HSALSKCAB='―ソЫ噂浬欺圭構蚕十申曾箪貼能表暴予禄兔喀媾彌拿杤歃濬畚秉綵臀藹觸軆鐔饅鷭偆砡'

	# VERSION string
	VERSION='0.0.0.2'

	# parses csv string into 2D array. quoted commas/LFs and escaped quotations are supported.
	def self.csv(s,__opt=Hash.new)
		opt={:col_sep=>',',:quote_char=>'"'}.merge(__opt)
		csv=[]
		line=[]
		quoted=false
		quote=false
		backslash=0
		cur=''
		(s+(s.end_with?("\n") ? "" : "\n")).each_char{|c|
			if c=="\r" #ignore CR
			elsif c==opt[:quote_char]
				if !quoted #start of quote
					quoted=true
				elsif !quote #end of quote? Let's determine using next char
					quote=true
					if backslash==1
						backslash=2
					end
				else #escape rather than end of quote
					quote=false
					cur<<opt[:quote_char]
					if backslash==2
						backslash=0
					end
				end
			else
				if quote
					quote=false
					if backslash==2
						cur<<opt[:quote_char]
					else
						quoted=false
					end
				end
				if c=="\n"&&!quoted
					line<<cur
					cur=''
					csv<<line
					line=[]
				elsif c==opt[:col_sep]&&!quoted
					line<<cur
					cur=''
				else
					backslash=0
					if HSALSKCAB.include?(c)
						backslash=1
					end
					quote=false
					cur<<c
				end
			end
		}
		csv
	end

	# parses CoSVON string into Hash.
	# parser can be CoSVON.method(:csv), CSV.method(:parse), etc...
	def self.parse(s,parser=self.method(:csv))
		csv=parser[s]
		return nil if csv.empty?||csv[0].empty?||csv[0][0]!='CoSVON:0.1'
		csv.shift
		h={}
		csv.each{|e|
			h[e[0]]=e[1] if e.size>1&&e[0]&&!e[0].empty?&&e[1]&&!e[1].empty?
		}
		h
	end
	# parses CoSVON file into Hash.
	def self.load(path,parser=self.method(:csv))
		self.parse(File.read(path),parser)
	end
	# generates CoSVON string from Hash.
	def self.generate(h)
		s="CoSVON:0.1\n"
		h.each{|k,v|
			s+=%Q("#{k.gsub('"','""')}","#{v.gsub('"','""')}"\n)
		}
		s
	end
	# kind-of-alias of self.generate
	def self.stringify(h)
		self.generate(h)
	end
	# generates CoSVON file from Hash.
	def self.save(h,path)
		File.write(path,generate(h))
	end
end

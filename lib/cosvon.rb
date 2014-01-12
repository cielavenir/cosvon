# CoSVON: Comma Separated Value Object Notation (yokohamarb)
#
# http://nabetani.sakura.ne.jp/yokohamarb/2014.01.cosvon/

class CoSVON
	# VERSION string
	VERSION='0.0.0.1'

	# parses csv string into 2D array. quoted commas/LFs and escaped quotations are supported.
	def self.csv(s)
		csv=[]
		line=[]
		quoted=false
		quote=false
		cur=''
		(s+(s.end_with?("\n") ? "" : "\n")).each_char{|c|
			if c=="\r" #ignore CR
			elsif c=='"'
				if !quoted #start of quote
					quoted=true
				elsif !quote #end of quote? Let's determine using next char
					quote=true
				else #escape rather than end of quote
					quote=false
					cur<<'"'
				end
			else
				if quote
					quote=false
					quoted=false
				end
				if c=="\n"&&!quoted
					line<<cur
					cur=''
					csv<<line
					line=[]
				elsif c==","&&!quoted
					line<<cur
					cur=''
				else
					cur<<c
				end
			end
		}
		csv
	end

	# parses CoSVON string into Hash.
	def self.parse(s)
		csv=self.csv(s)
		return nil if csv.empty?||csv[0].empty?||csv[0][0]!='CoSVON:0.1'
		csv.shift
		h={}
		csv.each{|e|
			h[e[0]]=e[1] if e.size>1&&!e[0].empty?&&!e[1].empty?
		}
		h
	end
	# parses CoSVON file into Hash.
	def self.load(path)
		self.parse(File.read(path))
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

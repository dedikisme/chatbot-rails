class ChatController < ApplicationController

  def create
   if cookies[:log]==nil or Chat.where(_id: cookies[:log]).count==0
    data={"ip"=> request.remote_ip, "pesan"=>{}}
    c=Chat.create(data)
    cookies[:log] = { :value => c._id, :expires => Time.now + 3600}
  else
    cookies[:log] = { :value => cookies[:log], :expires => Time.now + 3600}

  end
  kalimat=chat_params['pesan']
  if kalimat!=''
    Chat.where(_id: cookies[:log]).set(:pesan => insertpesan(kalimat))
    Chat.where(_id: cookies[:log]).set(:pesan => insertpesan(jawab(cekkatatanya(kalimat.delete "?"),cektopik(kalimat.delete "?"))))
#    Chat.where(_id: cookies[:log]).set(:pesan => insertpesan(cekkatatanya(kalimat.delete "?")))
end
end

def show

  @chat=Chat.where(_id: cookies[:log]).last
  @cookies=cookies[:log]
  cookies[:log] = { :value => cookies[:log], :expires => Time.now + 3600}
end

def index

end

def jawab(tanya,topik)

  if topik!=nil
    if tanya["tanya"] == 'siapa' and topik.type== 'orang'
      tanya["tanya"]='apa'
    end
    case tanya["tanya"] 
    when 'apa'
      hasil= cekdata(topik.adalah)
    when 'almamater'
      hasil= cekdata(topik.almamater,"#{topik.topik} lulusan dari")
    when 'kerja'
      hasil=cekdata(topik.pekerjaan,"Pekerjaan #{topik.topik} adalah ")

    when 'siapa'
      hasil=cekdata(topik.oleh.to_s,"pendiri #{topik.topik} adalah")
    when 'kapan'
      di=(topik.type=="orang")? "dilahirkan" : "dibuat"
      hasil=cekdata(topik.kapan.to_s, " #{topik.topik} #{di} pada")
    when 'alamat'
      hasil= cekdata(topik.situs,"Alamat #{topik.topik} adalah")
    when 'platform'
      hasil=(topik.count==0)? "maaf data tidak ditemukan" : topik.platform.join(', ')
    when 'fitur'
      hasil=(topik.fitur==nil)? "maaf data tidak ditemukan" : topik.fitur.join(', ')

    when 'macamfitur'
      c = Datum.where(:fitur.in => tanya["param"])
      data=Array.new
      for i in 0..c.count-1
        data[i]=c[i].topik
      end
      hasil="aplikasi yang memiliki fitur #{tanya['param'][0]} antara lain " + data.join(', ')
    when 'macamplatform'
      c = Datum.where(:platform.in => tanya["param"])
      data=Array.new
      for i in 0..c.count-1
        data[i]=c[i].topik
      end
      hasil="aplikasi yang support dengan  #{tanya['param'][0]} antara lain " + data.join(', ')
    else

      hasil=(tanya["tanya"]==nil)?  "maaf, silahkan menggunakan kata tanya"  : "maaf, data tidak ditemukan"    
    end
  else
    hasil="maaf, data tidak ditemukan"
  end



  return hasil


end

def cekdata(data, hasil=nil)

  hasil=(hasil==nil)? '': hasil ;
  return (data==nil)? "maaf data tidak ditemukan" : hasil +" " + data;
  
end
def insertpesan(data)
 chat=Chat.where(_id: cookies[:log]).last
 datapesan=chat.pesan
 ardata=(chat.pesan===nil)? 1 : datapesan.count+1; 

 datapesan[ardata]=data
 return datapesan
end
def chat_params
  params.permit(:pesan)
end

def cektopik(data)
  ardata=data.split(' ')
  d= Datum.where(:keywords.in => ardata).first

  return (d==nil)? nil : d;
end

def cekkatatanya(data)

  ardata=data.split(' ')
  hasil={}
  tanya={}
  tanya["kerja"]=["kerja","pekerjaan"]
  tanya["almamater"]=["sekolah","kuliah","akademik","universitas","almamater","kampus","belajar"]
  tanya["kapan"] = ["kapan","kpn"]
  tanya["bagaimana"] = ["gimana","bagaimana","gmn"]
  tanya["siapa"]=["sapa","siapa","siapakah","pendiri","pembuat","pencipta"]
  tanya["alamat"]=["alamat","almt","situs","url","domain"]
  tanya["macam"]=["saja","macam","jenis"]
  tanya["fitur"]=["fitur","fasilitas"]
  tanya["platform"]=["support","platform","device"]
  tanya["apa"] = ["apa","apakah"]
  tanya.each do | katanya |

    katatanya= katanya[0]
    tanya[katatanya].each do | datanya |
      if ardata.include? datanya
        hasil["tanya"]=katatanya
        break
      end
    end
    if hasil["tanya"]!=nil
      break
    end
  end
  katatanya=''
  datata=Array.new
  datamacam={}
  datamacam['macamfitur']=["chat","video","foto","gambar","musik","mp3"]
  datamacam['macamplatform']=["android","web","windows","ios","iphone","symbian","blackberry"]
  if hasil["tanya"]=="macam"
    datamacam.each do | katanya |

      katatanya = katanya[0]

      datamacam[katatanya].each do | datanya |

        if ardata.include? datanya
          hasil["tanya"]=katatanya
          hasil["param"]=[datanya]
          break
        end
      end

      if hasil["param"]!=nil
        break
      end
    end
  end  

  if hasil["tanya"]=="macam"
    tanya={}
    tanya["fitur"]=["fitur","fasilitas"]
    tanya["platform"]=["support","platform","device"]


    tanya.each do | katanya |

      katatanya= katanya[0]
      tanya[katatanya].each do | datanya |
        if ardata.include? datanya
          hasil["tanya"]=katatanya
          break
        end
      end
      if hasil["tanya"]!='macam'
        break
      end
    end

  end
  return  hasil;
end
end

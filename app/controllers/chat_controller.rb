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
    kalimat=kalimat.downcase
    Chat.where(_id: cookies[:log]).set(:pesan => insertpesan(jawab(cekkatatanya(kalimat.delete "?"),cektopik(kalimat.delete "?"))))
#    Chat.where(_id: cookies[:log]).set(:pesan => insertpesan(cekkatatanya(kalimat.delete "?")))
end
end

def show

  @chat=Chat.where(_id: cookies[:log]).last
  @cookies=cookies[:log]
  @topik=cookies[:topik]
  cookies[:log] = { :value => cookies[:log], :expires => Time.now + 3600}
  @scroll = params[:scroll];
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
    when 'lokasi'
      hasil= cekdata(topik.lokasi)
    when 'almamater'
      hasil= cekdata(topik.almamater,"#{topik.topik} lulusan dari")
    when 'kerja'
      hasil=cekdata(topik.pekerjaan,"Pekerjaan #{topik.topik} adalah ")
   when 'perusahaan'
      hasil=cekdata(topik.perusahaan,"Perusahaan dari #{topik.topik} adalah ")

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
 when 'macamsocmed'
      c = Datum.where(type: "socmed")
      data=Array.new
      for i in 0..c.count-1
        data[i]=c[i].topik
      end
      hasil="Macam socmed antara lain " + data.join(', ')
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
  data=data.downcase
  ardata=data.split(' ')
  d= Datum.where(:keywords.in => ardata).first
  hasil=nil
  if d==nil
    hasil= Datum.where(_id: cookies[:topik] ).first
  else
    hasil=d
    cookies[:topik] = { :value => d._id, :expires => Time.now + 3600}
  end
  return hasil
end

def cekkatatanya(data)

  ardata=stemming(data)
  hasil={}
  tanya={}
  tanya["kerja"]= %w(kerja pekerjaan)
  tanya["lokasi"]= %w(lokasi tempat)
  tanya["perusahaan"]= %w(usaha instansi milik)
  tanya["almamater"]= %w(sekolah kuliah akademik universitas almamater kampus belajar)
  tanya["kapan"] = %w(kapan kpn)
  tanya["bagaimana"] = %w(gimana bagaimana gmn)
  tanya["siapa"]= %w(sapa siapa diri buat cipta)
  tanya["alamat"]= %w(alamat almt situs url domain)
    tanya["macam"]=%w(saja macam jenis)

  tanya["fitur"]=%w(fitur fasilitas)
  tanya["platform"]=%w(support platform device)
  tanya["apa"] = %w(apa adalah)
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
  datamacam['macamfitur']= %w(chat video foto gambar musik mp3)
  datamacam['macamplatform']= %w(android web windows ios iphone symbian blackberry)
  datamacam['macamsocmed']= %w(jejaring sosial socmed social media)
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
    tanya["fitur"]= %w(fitur fasilitas)
    tanya["platform"]= %w(support platform device)


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
def stemming(kalimat)
   data=Array.new
  katakata=Kata.first
  ardata=kalimat.split(" ")
  for i in 0..ardata.count-1
    datatemp=ardata[i].stem
         data[i]=datatemp
    for y in 0..katakata.data.count-1
      if katakata.data[y] == datatemp
                 data[i]=datatemp

            break
end
     if Levenshtein.distance(katakata.data[y], datatemp) ==1
                    data[i]=  katakata.data[y]
    end
  end
end
puts data
  return data
end
def hapusawalan
  
end
end

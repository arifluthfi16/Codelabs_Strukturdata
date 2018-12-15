program sl;
uses crt;

type
    point = ^data;
    Data = Record
           info : integer;
           next,prev : point;
           end;

    stack_point = ^Stack_data;
    Stack_data = Record
                    info : integer;
                    next : stack_point
                end;
    
    queue_point = ^queue_data;
    queue_data = Record
                    info : integer;
                    next : queue_point;
                end;
    
            
var 
    head,tail : queue_point;
    top,bottom : stack_point;
    awal_dl,akhir_dl : point;
    inp,out,pilihan,sub1,sub2,sub3 : integer;

procedure creation(awal,akhir : point);
    begin
       awal_dl := nil;
       akhir_dl := nil; 
    end;

//Linked List
procedure list_sisipdepan(data : integer;var awal,akhir : point);
    var
        baru : point;
    begin
        new(baru);
        baru^.info := data;
        if(awal = nil) then 
            begin
                baru^.next := nil;
                baru^.prev := nil;
                akhir := baru;

            end
        else
            begin
                awal^.prev := baru;
                baru^.prev := nil;
                baru^.next := awal;  
            end;
        awal := baru;
    end; //End Sisip Depan

procedure list_sisipbelakang(data : integer; var awal,akhir : point);
    var 
        baru : point;
    begin  
        new(baru);
        baru^.info := data;
        if(awal = nil) then
            begin
                list_sisipdepan(data,awal,akhir);
            end
        else
            begin                

                baru^.prev := akhir;
                akhir^.next := baru;
                baru^.next := nil;
            end;
        akhir := baru;
    end;

procedure list_sisip_setelah(data,cari : integer; var awal,akhir : point);
    var 
        baru,bantu : point;
        ketemu : boolean;
    begin
        ketemu := false;
        bantu := awal;
        new(baru);
        baru^.info := data;
        if(awal = nil) then
            begin
               list_sisipdepan(data,awal,akhir);  
            end
        else
            begin
               while(not ketemu) AND (bantu <> nil)do 
                begin
                    if (bantu^.info = cari) then
                        begin
                            ketemu := true;
                        end
                    else
                        begin
                            bantu := bantu^.next;
                        end;
                
                end;
                if(ketemu) then
                    begin
                        if(bantu = akhir) then
                            begin
                                list_sisipbelakang(data,awal,akhir); 
                            End
                        else
                            begin
                                baru^.next := bantu^.next;
                                bantu^.next := baru;
                                baru^.prev := bantu;
                                baru^.next^.prev := baru;     
                            end;
                        
                    end; 
            end;
    end;

procedure list_showall(awal:point);
    var
        bantu : point;
    begin
        bantu := awal;
        clrscr;
        writeln('Menampilkan semua data tersimpan');
        while(bantu <> nil ) do 
            begin
                writeln(bantu^.info);
                bantu := bantu^.next;
            end;
            readln;
    end;

//Double Linked List Penghapusan
procedure set_nil_linklist(var awal,akhir : point);
begin
    awal^.next := nil;
    awal^.prev := nil;
    akhir^.next := nil;
    akhir^.prev := nil;
end;

procedure hapus_depan(var out: integer;var awal,akhir : point);
var
    phapus : point;
begin
    phapus := awal;
    out := phapus^.info;

    if(awal = akhir) then
        begin
            set_nil_linklist(awal,akhir);
            writeln('Data berhasil dihapus');
        end
    else if(awal = nil) then
        begin
            writeln('Tidak ada data yang dapat dihapus');
        end
    else
        begin
            awal := awal^.next;
            awal^.prev := nil;
            phapus^.next := nil;
            writeln('Data depan dihapus');
        end;
    dispose(phapus);
end;

procedure hapus_belakang(var out: integer;var awal,akhir : point);
    var
        phapus : point;
    begin
        phapus := akhir;
        out := phapus^.info;

        if(awal = akhir) then
            begin
                set_nil_linklist(awal,akhir);
                writeln('Data berhasil dihapus');
            end
        else if(awal = nil) then
            begin
                writeln('Tidak ada data yang dapat dihapus');
            end
        else
            begin
                akhir := akhir^.prev;
                akhir^.next := nil;
                phapus^.prev := nil;
                writeln('Penghapusan belakang sukses');
            end;
        dispose(phapus);    
    end;

procedure hapus_tengah(cari : integer;var out: integer;var awal,akhir:point);
    var
        phapus : point;
        ketemu : boolean;
    begin
        ketemu := false;
        phapus := awal;

        if(awal = akhir) then
            begin
                set_nil_linklist(awal,akhir);
                writeln('Data berhasil dihapus');
            end
        else if(awal = nil) then
            begin
                writeln('Tidak ada data yang dapat dihapus');
            end
        else
            begin
                while(phapus <> nil) and (not ketemu) do
                    begin
                        if(phapus^.info = cari) then
                            begin
                                ketemu := true;
                            end
                        else
                            begin
                                phapus := phapus^.next;
                            end;    
                    end;
                if (ketemu) then
                    begin
                        if(phapus = awal) then hapus_depan(out,awal,akhir)
                        else if(phapus = akhir) then hapus_belakang (out,awal,akhir)
                        else
                            begin
                                phapus^.prev^.next := phapus^.next;
                                phapus^.next^.prev := phapus^.prev;
                                phapus^.prev := nil;
                                phapus^.next := nil;  
                            end;
                    end
                else
                    begin
                        writeln('Data tidak ditemukan');
                    end;
            end;
        dispose(phapus);    
        
    end;

//Stack
procedure create_stack(var top : stack_point);
begin
    top := nil;
end;

procedure push(data : integer;var top,bottom : stack_point);
var
    baru : stack_point;
begin
    new(baru);
    baru^.info := data;

    if(top = nil) then
        begin
            baru^.next := nil;
            bottom := baru;
        end
    else
        begin
            baru^.next := top;
        end;
    top := baru;
end;

procedure pop(var out: integer;var top : stack_point);
var
    phapus : stack_point;
begin
    phapus := top;
    out := phapus^.info;

    if(top=bottom) then
        begin
            top := nil;
            bottom := nil;
        end
    else
        begin
            top := top^.next;
            phapus^.next := nil;
        end;
    dispose(phapus);
end;

procedure stack_show(top : stack_point);
    var
        bantu : stack_point;
    begin
        clrscr;
        bantu := top;
        writeln('Showing stack data');
        while(bantu <> nil) do 
            begin
                writeln(bantu^.info);
                bantu:=bantu^.next;
            end;
        readln;
    end;

//Queue
procedure Enqueue(data : integer; var head,tail : queue_point);
    var 
        baru : queue_point;
    begin
        new(baru);
        baru^.info := data;

        if(head = nil) then
            begin
                baru^.next := nil;
                head := baru;
            end
        else
            begin
                tail^.next := baru;
                baru^.next := nil;
            end;
        tail := baru;
    end;

procedure Dequeue(out : integer; var head : queue_point);
    var
        phapus : queue_point;
    begin
        phapus := head;
        out := phapus^.info;

        if(head = tail) then
            begin
                head := nil;
                tail := nil;
            end
        else if(phapus = nil) then
            begin
                writeln('Data kosong')
            end
        else
            begin
                head := head^.next;
                phapus^.next := nil;
            end;
        dispose(phapus);
    end;

procedure queue_show(head : queue_point);
var
    bantu : queue_point;
begin
    clrscr;
    bantu := head;
    writeln('Showing queue data');
    while(bantu <> nil) do
        begin
            writeln(bantu^.info);
            bantu := bantu^.next;
        end;
        readln;
end;

begin //Begin Program
    creation(awal_dl,akhir_dl);
    create_stack(top);
    repeat
        clrscr;
        writeln('1. Linkedlist');
        writeln('2. Stack');
        writeln('3. Queue');
        writeln('0. Exit');
        writeln();
        write('Masukkan pilihan anda : ');readln(pilihan);

        case (pilihan) of
            1: //Menu 1
                begin
                  repeat
                      clrscr;
                      writeln('1. Sisip depan');
                      writeln('2. Sisip belakang');
                      writeln('3. Sisip Tengah');
                      writeln('4. Hapus Depan');
                      writeln('5. Hapus Belakang');
                      writeln('6. Hapus Tengah');
                      writeln('7. Tampilkan Semua data');
                      writeln('0. Exit');

                      write('Masukkan pilihan anda : ');readln(sub1);
                    clrscr;
                    case (sub1) of
                        1: 
                            begin
                                write('Masukkan data : ');readln(inp);
                                list_sisipdepan(inp,awal_dl,akhir_dl);  
                            end;
                        2: 
                            begin
                                write('Masukkan data : ');readln(inp);
                                list_sisipbelakang(inp,awal_dl,akhir_dl);
                            end;
                        3: 
                            begin
                                write('Masukkan data : ');readln(inp);
                                write('Sisipkan data setelah : ');readln(out);
                                list_sisip_setelah(inp,out,awal_dl,akhir_dl);
                            end;
                        4: 
                            begin
                                hapus_depan(out,awal_dl,akhir_dl); 
                            end;
                        5: 
                            begin
                                hapus_belakang(out,awal_dl,akhir_dl); 
                            end;
                        6: 
                            begin
                                write('Masukkan data yang akan dihapus : ');readln(inp);
                                hapus_tengah(inp,out,awal_dl,akhir_dl); 
                            end;
                        7: 
                            begin
                                list_showall(awal_dl);
                            end;
                        
                    end;
                  until (sub1=0);  
                end;
            2: //Stack 
                begin
                    clrscr;
                    repeat
                        writeln('1. Push');
                        writeln('2. Pop');
                        writeln('3. Show Data');
                        writeln('0. Exit');
                        writeln;
                        write('Masukkan pilihan anda : ');readln(sub2);
                        clrscr;
                            case (sub2) of
                                1: 
                                    begin
                                        write('Masukkan data : ');readln(inp);
                                        push(inp,top,bottom);
                                    end;
                                2: 
                                    begin
                                        pop(out,top);
                                    end;
                                3: 
                                    begin
                                        stack_show(top);
                                    end;
                            end;
                    until(sub2 = 0);
                end;
            3: //Queue 
                begin
                    clrscr;
                    repeat
                        writeln('1. Enqueue');
                        writeln('2. Dequeue');
                        writeln('3. Show Data');
                        writeln('0. Exit');
                        writeln;
                        write('Masukkan pilihan anda : ');readln(sub3);
                        clrscr;
                            case (sub3) of
                                1: 
                                    begin
                                        write('Masukkan data : ');readln(inp);
                                        Enqueue(inp,head,tail);
                                    end;
                                2: 
                                    begin
                                        Dequeue(out,head);
                                    end;
                                3:
                                    begin
                                        queue_show(head);
                                    end;
                            end;
                    until(sub3 = 0);
                end;
        end;
    until (pilihan = 0);
end.
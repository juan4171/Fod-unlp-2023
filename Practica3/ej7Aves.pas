program ej7Aves;
{ej7. Se cuenta con un archivo que almacena informaci�n sobre especies de aves en
v�a de extinci�n, para ello se almacena: c�digo, nombre de la especie, familia de ave,
descripci�n y zona geogr�fica. El archivo no est� ordenado por ning�n criterio. Realice
un programa que elimine especies de aves, para ello se recibe por teclado las especies a
eliminar. Deber� realizar todas las declaraciones necesarias, implementar todos los
procedimientos que requiera y una alternativa para borrar los registros. Para ello deber�
implementar dos procedimientos, uno que marque los registros a borrar y posteriormente
otro procedimiento que compacte el archivo, quitando los registros marcados. Para
quitar los registros se deber� copiar el �ltimo registro del archivo en la posici�n del registro
a borrar y luego eliminar del archivo el �ltimo registro de forma tal de evitar registros
duplicados.
Nota: Las bajas deben finalizar al recibir el c�digo 500000

* hay algunos metodos que no pide el ej pero yo los uso para generar los archivos
binarios necesarios, creandolos desde archivos .txt con el objetivo de poder probar el program

}

const
    VALORALTO = 9999;
    DIREC = 'C:\Users\juan8\Desktop\FOD2023\Practica3\archivosFOD\ej7\';
    MAESTRO_BINARIO = DIREC+'maestro';
    MAESTRO_TXT = DIREC+'maestro.txt';            {* no lo pide el ej}
type
    ave = record
        cod: integer;
        fam: integer;
        zona: integer;
        nom: string[50];
        desc: string[50];
    end;
    maestro = file of ave;

procedure leer(var archivo: maestro; var dato: ave);
begin
    if (not(EOF(archivo))) then 
        read(archivo, dato)
    else 
        dato.cod := valoralto;
end;

procedure actualizar(var mae1: maestro);    {podria llamarse baja logica}
var
    regm: ave;
    c: integer;
begin
    reset (mae1);
    writeln('Comienza el borrado de aves del archivo:');
    writeln('Ingrese el codigo de ave que quiera eliminar del archivo (50 para terminar):');
    readln(c);
    while (c <> 50) do {50 para no poner 500000}
    begin
        leer(mae1, regm);
        while((regm.cod <> VALORALTO) and (regm.cod <> c)) do {no asumo que si o si encuentre}
        begin
             leer(mae1, regm);
        end;
        if (regm.cod = c) then
        begin
            regm.cod:= -(regm.cod);
            seek (mae1, filepos(mae1)-1);
            write(mae1, regm);
            writeln('Ave codigo ', c ,' marcada como eliminada exitosamente.');
        end
        else
        begin
            writeln('El codigo de ave ingresado no existe en el archivo, intente nuevamente.');
        end; 
        writeln('Ingrese el codigo de ave que quiera eliminar del archivo (50 para terminar):');
        readln(c);
        seek (mae1, 0);   {necesario para volver a buscar desde el principio}
    end;
    writeln('Fin de marcado de aves para borrar.');
    close(mae1);
end;

procedure borrarAves(var archivo : maestro);    {podria llamarse compactar o baja fisica}
var
    pos_de_reemplazo: integer;
    reg, ultimo: ave;
begin
    reset(archivo);
    leer(archivo, reg);
    while (reg.cod <> VALORALTO) do
    begin
        if (reg.cod < 0) then
        begin
            if (filepos(archivo)-1 = filesize(archivo)-1) then {si estoy en el unico o el ultimo registro}
            begin                                              {no es necesario este if porque con lo que hago en el else funciona igual}
                seek(archivo, filesize(archivo)-1 );  {pero supongo que en el caso de ser el ultimo registro es "mejor" hacer solo estas 2 cosas}
                truncate(archivo);    
            end
            else 
            begin
                pos_de_reemplazo:= filepos(archivo)-1;  {guardo la pos donde esta lo que voy a sobre escribir}
                seek(archivo, filesize(archivo)-1 );    {guardo el ultimo}
                read(archivo, ultimo);                  {guardo el ultimo}
                seek(archivo, pos_de_reemplazo);        {copio el ultimo en la pos a sobre escribir}
                write(archivo, ultimo);                 {copio el ultimo en la pos a sobre escribir}
                seek(archivo, filesize(archivo)-1 );    {trunco el ultimo}
                truncate(archivo);                      {trunco el ultimo}
                seek(archivo,pos_de_reemplazo);          {vuelo a la pos a sobre escrita por si sobre escribi algo a borrar}
            end;            
            writeln('Se borro ave y el archivo quedo con ',filesize(archivo),' posiciones');
        end;
        leer(archivo, reg);
    end;
    close(archivo);
end;

{* no lo pide el ej}
procedure maestro_txt_a_binario(var carga: text; var mae: maestro);
var
    reg: ave;
    espacio: char;
begin
    reset(carga);
    rewrite(mae);
    while(not EOF(carga))do begin
        with reg do
        begin
            readln(carga, cod, zona, fam, espacio, nom);
            readln(carga, desc);
        end;
        write(mae, reg);
    end;
    close(mae);
    close(carga);
end;

procedure imprimir(reg: ave);      {* no lo pide el ej}
begin
    with reg do
    begin
        writeln('- ave cod: ',cod,' - zona: ', zona,' - familia: ',fam,' - nombre: ',nom,' - descripcion: ',desc);
    end;
end;

procedure mostrarListaCompleta(var arc_logico: maestro);   {* no lo pide el ej}
var
    reg: ave;
begin
    reset(arc_logico);
    writeln('Lista completa de elementos en la lista:');
    while(not eof(arc_logico))do begin
        read(arc_logico, reg);
        imprimir(reg);
    end;
    writeln('Final de la Lista.');
    close(arc_logico);
end;

var
    mae1 : maestro;
    mae1_txt : text;    {* no lo pide el ej}
begin
    assign( mae1, MAESTRO_BINARIO); 
    assign( mae1_txt, MAESTRO_TXT);         {* no lo pide el ej}
    maestro_txt_a_binario(mae1_txt, mae1);     {* no lo pide el ej}
    mostrarListaCompleta(mae1);             {* no lo pide el ej}

    actualizar(mae1);
    mostrarListaCompleta(mae1);     {* no lo pide el ej}
    borrarAves(mae1); {compactar}
    mostrarListaCompleta(mae1);     {* no lo pide el ej}

    writeln('----');
    writeln('-Programa finalizado.-');
    readln();
end.

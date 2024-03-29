
/**************************************************************************************************
* DS1307 Functions
**************************************************************************************************/

// Declaraci�n de estructuras
typedef struct
{
     unsigned short Hor, Min, Seg;
}Hora;
typedef struct
{
     unsigned short Dia, Fec, Mes, Ano;
}Fecha;

//Funci�n para definir direcci�n de memoria.
void DS1307SetDir( unsigned short dir )
{
     Soft_I2C_Start();
     Soft_I2C_Write(0xD0);
     Soft_I2C_Write(dir);
}
//Funci�n para convertir de c�digo Bcd a Entero.
unsigned short BcdToShort( unsigned short bcd )
{
     unsigned short LV, HV;
     LV = bcd&0x0F;
     HV = (bcd>>4)&0x0F;
     return LV + HV*10;
}
//Funci�n para convertir de Entero a Bcd.
unsigned short ShortToBcd( unsigned short valor )
{
     unsigned short HV, LV;
     HV = valor/10;
     LV = valor - HV*10;
     return LV + HV*16;
}
//Funci�n para inicializar el DS1307.
void DS1307Inicio( void )
{
    unsigned short VAL[7], HV, LV, DATO;
    Soft_I2C_Init(); //Inicio del bus I2C.
    delay_ms(50); //Retardo.
    //Lectura de las primeras 7 direcciones.
    DS1307SetDir(0);
    Soft_I2C_Start();
    Soft_I2C_Write(0xD1);
    VAL[0] = Soft_I2C_Read(1);
    VAL[1] = Soft_I2C_Read(1);
    VAL[2] = Soft_I2C_Read(1);
    VAL[3] = Soft_I2C_Read(1);
    VAL[4] = Soft_I2C_Read(1);
    VAL[5] = Soft_I2C_Read(1);
    VAL[6] = Soft_I2C_Read(0);
    Soft_I2C_Stop();
    delay_ms(50); //Retardo.
    //Validaci�n y correcci�n de informaci�n,
    //como hora y fecha.
    DATO = BcdToShort( VAL[0] );
    if( DATO > 59 )VAL[0]=0;
    DATO = BcdToShort( VAL[1] );
    if( DATO>59 )VAL[1]=0;
    DATO = BcdToShort( VAL[2] );
    if( DATO>23 )VAL[2]=0;
    DATO = BcdToShort( VAL[3] );
    if( DATO>7 || DATO==0 )VAL[3]=1;
    DATO = BcdToShort( VAL[4] );
    if( DATO>31 || DATO==0 )VAL[4]=1;
    DATO = BcdToShort( VAL[5] );
    if( DATO>12 || DATO==0 )VAL[5]=1;
    DATO = BcdToShort( VAL[6] );
    if( DATO>99 )VAL[6]=0;
    //Grabaci�n de las primeras 7 direcciones.
    DS1307SetDir(0);
    Soft_I2C_Write(VAL[0]);
    Soft_I2C_Write(VAL[1]);
    Soft_I2C_Write(VAL[2]);
    Soft_I2C_Write(VAL[3]);
    Soft_I2C_Write(VAL[4]);
    Soft_I2C_Write(VAL[5]);
    Soft_I2C_Write(VAL[6]);
    Soft_I2C_Write(0x10); //Se activa la salida oscilante 1Hz.
    Soft_I2C_Stop();
    delay_ms(50); //Retardo.
}
//Funci�n para grabar la hora minutos y segundos.
void DS1307SetHora( Hora h )
{
    DS1307SetDir(0);
    Soft_I2C_Write( ShortToBcd(h.Seg) );
    Soft_I2C_Write( ShortToBcd(h.Min) );
    Soft_I2C_Write( ShortToBcd(h.Hor) );
    Soft_I2C_Stop();
}
//Funci�n para grabar el d�a, fecha, mes, y a�o.
void DS1307SetFecha( Fecha f )
{
    DS1307SetDir(3);
    Soft_I2C_Write( ShortToBcd(f.Dia) );
    Soft_I2C_Write( ShortToBcd(f.Fec) );
    Soft_I2C_Write( ShortToBcd(f.Mes) );
    Soft_I2C_Write( ShortToBcd(f.Ano) );
    Soft_I2C_Stop();
}
//Funci�n para leer la hora minutos y segundos.
Hora DS1307GetHora( void )
{
    Hora H;
    unsigned short VAL[3];
    DS1307SetDir(0);
    Soft_I2C_Start();
    Soft_I2C_Write(0xD1);
    VAL[0] = Soft_I2C_Read(1);
    VAL[1] = Soft_I2C_Read(1);
    VAL[2] = Soft_I2C_Read(0);
    Soft_I2C_Stop();
    H.Seg = BcdToShort( VAL[0] );
    H.Min = BcdToShort( VAL[1] );
    H.Hor = BcdToShort( VAL[2] );
    return H;
}
//Funci�n para leer el d�a, fecha, mes, y a�o.
Fecha DS1307GetFecha( void )
{
    Fecha F;
    unsigned short VAL[4];
    DS1307SetDir(3);
    Soft_I2C_Start();
    Soft_I2C_Write(0xD1);
    VAL[0] = Soft_I2C_Read(1);
    VAL[1] = Soft_I2C_Read(1);
    VAL[2] = Soft_I2C_Read(1);
    VAL[3] = Soft_I2C_Read(0);
    Soft_I2C_Stop();
    F.Dia = BcdToShort( VAL[0] );
    F.Fec = BcdToShort( VAL[1] );
    F.Mes = BcdToShort( VAL[2] );
    F.Ano = BcdToShort( VAL[3] );
    return F;
}
// Funciones para leer y grabar datos individuales //
//Funci�n para leer las horas.
unsigned short DS1307GetHoras( void )
{
    Hora h;
    h=DS1307GetHora();
    return h.Hor;
}
//Funci�n para leer los minutos.
unsigned short DS1307GetMinutos( void )
{
    Hora h;
    h=DS1307GetHora();
    return h.Min;
}
//Funci�n para leer los segundos.
unsigned short DS1307GetSegundos( void )
{
    Hora h;
    h=DS1307GetHora();
    return h.Seg;
}
//Funci�n para grabar las horas.
void DS1307SetHoras( unsigned short ho )
{
    Hora h;
    h=DS1307GetHora();
    h.Hor = ho;
    DS1307SetHora( h );
}
//Funci�n para grabar los minutos.
void DS1307SetMinutos( unsigned short mi )
{
    Hora h;
    h=DS1307GetHora();
    h.Min = mi;
    DS1307SetHora( h );
}
//Funci�n para grabar los segundos.
void DS1307SetSegundos( unsigned short se )
{
    Hora h;
    h=DS1307GetHora();
    h.Seg = se;
    DS1307SetHora( h );
}
//Funci�n para leer el d�a de la semana.
unsigned short DS1307GetDias( void )
{
    Fecha f;
    f=DS1307GetFecha();
    return f.Dia;
}
//Funci�n para leer la fecha del mes.
unsigned short DS1307GetFechas( void )
{
    Fecha f;
    f=DS1307GetFecha();
    return f.Fec;
}
//Funci�n para leer el mes del a�o.
unsigned short DS1307GetMeses( void )
{
    Fecha f;
    f=DS1307GetFecha();
    return f.Mes;
}
//Funci�n para leer el a�o.
unsigned short DS1307GetAnos( void )
{
    Fecha f;
    f=DS1307GetFecha();
    return f.Ano;
}
//Funci�n para grabar el dia de la semana.
void DS1307SetDias( unsigned short di )
{
    Fecha f;
    f=DS1307GetFecha();
    f.Dia = di;
    DS1307SetFecha(f);
}
//Funci�n para grabar la fecha del mes.
void DS1307SetFechas( unsigned short fe )
{
    Fecha f;
    f=DS1307GetFecha();
    f.Fec = fe;
    DS1307SetFecha(f);
}
//Funci�n para grabar el mes del a�o.
void DS1307SetMeses( unsigned short me )
{
    Fecha f;
    f=DS1307GetFecha();
    f.Mes = me;
    DS1307SetFecha(f);
}
//Funci�n para grabar el a�o.
void DS1307SetAnos( unsigned short an )
{
    Fecha f;
    f=DS1307GetFecha();
    f.Ano = an;
    DS1307SetFecha(f);
}

/**************************************************************************************************
* END DS1307 Functions
**************************************************************************************************/
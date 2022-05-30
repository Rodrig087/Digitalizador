
// Cabecera de las funciones DS1307_Functions

 //Declaración de estructuras
typedef struct
{
     unsigned short Hor, Min, Seg;
}Hora;
typedef struct
{
     unsigned short Dia, Fec, Mes, Ano;
}Fecha;

// Las funciones del DS1307 se encuentran en el archivo .c
// Se coloca al inicio extern para indicar que estan en un archivo externo .c
extern void DS1307SetDir( unsigned short dir );
extern unsigned short BcdToShort( unsigned short bcd );
extern unsigned short ShortToBcd( unsigned short valor );
extern void DS1307Inicio( void );
extern void DS1307SetHora( Hora h );
extern void DS1307SetFecha( Fecha f );
extern Hora DS1307GetHora( void );
extern Fecha DS1307GetFecha( void );
extern unsigned short DS1307GetHoras( void );
extern unsigned short DS1307GetMinutos( void );
extern unsigned short DS1307GetSegundos( void );
extern void DS1307SetHoras( unsigned short ho );
extern void DS1307SetMinutos( unsigned short mi );
extern void DS1307SetSegundos( unsigned short se );
extern unsigned short DS1307GetDias( void );
extern unsigned short DS1307GetFechas( void );
extern unsigned short DS1307GetMeses( void );
extern unsigned short DS1307GetAnos( void );
extern void DS1307SetDias( unsigned short di );
extern void DS1307SetFechas( unsigned short fe );
extern void DS1307SetMeses( unsigned short me );
extern void DS1307SetAnos( unsigned short an );
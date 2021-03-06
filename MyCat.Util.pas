unit MyCat.Util;

interface

uses
  System.SysUtils, System.DateUtils;

type
  // *
  // * 弱精度的计时器，考虑性能不使用同步策略。
  // *
  TTimeUtil = class
  public
    class function CurrentTimeMillis: Int64; static;
    class function CurrentTimeNanos: Int64; static;
  end;

  TDateTimeUtil = class
  public
    class function FULL_DATETIME_PATTERN: TFormatSettings; static;
    class function DEFAULT_DATETIME_PATTERN: TFormatSettings; static;
    class function ONLY_DATE_PATTERN: TFormatSettings; static;
    class function FULL_TIME_PATTERN: TFormatSettings; static;
    class function DEFAULT_TIME_PATTERN: TFormatSettings; static;

    // *
    // * 根据日期字符串解析得到date类型日期
    // * @param dateStr
    // * @return
    // * @throws ParseException
    // *
    class function ParseDateTime(DateTimeStr: string): TDateTime;
      overload; static;
    // *
    // * 根据日期字符串和日期格式解析得到date类型日期
    // * @param dateStr
    // * @param datePattern
    // * @return
    // * @throws ParseException
    // *
    class function ParseDateTime(DateTimeStr: string;
      DatePattern: TFormatSettings): TDateTime; overload; static;

    // *
    // * 获取date对象年份
    // * @param date
    // * @return
    // *
    class function GetYear(DateTime: TDateTime): Word; static;
    // /**
    // * 获取date对象月份
    // * @param date
    // * @return
    // */
    class function GetMonth(DateTime: TDateTime): Byte; static;
    // /**
    // * 获取date对象天数
    // * @param date
    // * @return
    // */
    class function GetDay(DateTime: TDateTime): Byte; static;
    // /**
    // * 获取date对象小时数
    // * @param date
    // * @return
    // */
    class function GetHour(DateTime: TDateTime): Byte; static;
    // /**
    // * 获取date对象分钟数
    // * @param date
    // * @return
    // */
    class function GetMinute(DateTime: TDateTime): Byte; static;
    // /**
    // * 获取date对象秒数
    // * @param date
    // * @return
    // */
    class function GetSecond(DateTime: TDateTime): Byte; static;
    // /**
    // * 获取date对象毫秒数
    // * @param date
    // * @return
    // */
    class function GetMicroSecond(DateTime: TDateTime): Word; static;
  end;

  TByteUtil = class
  private
    class function GetBytesFromTime(Time: TTime): TBytes; static;
    class function GetBytesFromDateTime(DateTime: TDateTime): TBytes; static;

  public
    // *
    // * compare to number or dicamal ascii byte array, for number :123456 ,store
    // * to array [1,2,3,4,5,6]
    // *
    // * @param b1
    // * @param b2
    // * @return -1 means b1 < b2, or 0 means b1=b2 else return 1
    // *
    class function CompareNumberByte(B1: TBytes; B2: TBytes): Integer; static;
    class function GetBytes(Data: SmallInt): TBytes; overload; static;
    class function GetBytes(Data: WideChar): TBytes; overload; static;
    class function GetBytes(Data: Integer): TBytes; overload; static;
    class function GetBytes(Data: Int64): TBytes; overload; static;
    class function GetBytes(Data: Single): TBytes; overload; static;
    class function GetBytes(Data: Double): TBytes; overload; static;
    class function GetBytes(Data: string; Encoding: TEncoding): TBytes;
      overload; static;
    class function GetBytes(DateTime: TDateTime; IsTime: boolean): TBytes;
      overload; static;
    class function GetBytes(Data: string): TBytes; overload; static;
    class function GetShort(Bytes: TBytes): SmallInt; static;
    class function GetChar(Bytes: TBytes): Char; static;
    class function GetInt(Bytes: TBytes): Integer; static;
    class function GetLong(Bytes: TBytes): Int64; static;
    class function GetDouble(Bytes: TBytes): Double; static;
    class function GetFloat(Bytes: TBytes): Single; static;
    class function GetString(Bytes: TBytes; Encoding: TEncoding): string;
      overload; static;
    class function GetString(Bytes: TBytes): string; overload; static;
    class function GetDate(Bytes: TBytes): string; static;
    class function GetTime(Bytes: TBytes): string; static;
    class function GetTimeStmap(Bytes: TBytes): string; static;
  end;

  // public class ByteUtil {
  //
  //
  //
  // public static byte[] getBytes() {
  // }
  //
  //
  // private static byte[] getBytesFromDate(Date date) {
  // }
  //
  // // 支持 byte dump
  // //---------------------------------------------------------------------
  // public static String dump(byte[] data, int offset, int length) {
  //
  // StringBuilder sb = new StringBuilder();
  // sb.append(" byte dump log ");
  // sb.append(System.lineSeparator());
  // sb.append(" offset ").append( offset );
  // sb.append(" length ").append( length );
  // sb.append(System.lineSeparator());
  // int lines = (length - 1) / 16 + 1;
  // for (int i = 0, pos = 0; i < lines; i++, pos += 16) {
  // sb.append(String.format("0x%04X ", i * 16));
  // for (int j = 0, pos1 = pos; j < 16; j++, pos1++) {
  // sb.append(pos1 < length ? String.format("%02X ", data[offset + pos1]) : "   ");
  // }
  // sb.append(" ");
  // for (int j = 0, pos1 = pos; j < 16; j++, pos1++) {
  // sb.append(pos1 < length ? print(data[offset + pos1]) : '.');
  // }
  // sb.append(System.lineSeparator());
  // }
  // sb.append(length).append(" bytes").append(System.lineSeparator());
  // return sb.toString();
  // }
  //
  // public static char print(byte b) {
  // return (b < 32 || b > 127) ? '.' : (char) b;
  // }
  //
  // }

implementation

{ TByteUtil }

class function TByteUtil.CompareNumberByte(B1, B2: TBytes): Integer;
var
  IsNegetive: boolean;
  Len: Integer;
  Index: Integer;
  i: Integer;
  LenDelta: Integer;
begin
  if length(B1) = 0 then
  begin
    Exit(-1);
  end
  else if length(B2) = 0 then
  begin
    Exit(1);
  end;
  IsNegetive := (B1[0] = 45) or (B2[0] = 45);
  if (IsNegetive = false) and (length(B1) <> length(B2)) then
  begin
    Exit(length(B1) - length(B2));
  end;
  if length(B1) > length(B2) then
  begin
    Len := length(B2);
  end
  else
  begin
    Len := length(B1);
  end;
  Result := 0;
  Index := -1;
  for i := 0 to Len - 1 do
  begin
    if (B1[i] > B2[i]) then
    begin
      Index := i;
      Result := 1;
      break;
    end
    else if (B1[i] < B2[i]) then
    begin
      Index := i;
      Result := -1;
      break;
    end;
  end;
  if Index = 0 then
  begin
    // first byte compare
    Exit;
  end
  else
  begin
    if length(B1) <> length(B2) then
    begin
      LenDelta := length(B1) - length(B2);
      if IsNegetive then
      begin
        Result := -LenDelta;
      end
      else
      begin
        Result := LenDelta;
      end;
    end
    else
    begin
      if IsNegetive then
      begin
        Result := -Result;
      end;
    end;
  end;
end;

class function TByteUtil.GetBytes(Data: SmallInt): TBytes;
begin
  SetLength(Result, 2);
  Result[0] := Byte(Data and $FF);
  Result[1] := Byte((Data and $FF00) shr 8);
end;

class function TByteUtil.GetBytes(Data: WideChar): TBytes;
begin
  SetLength(Result, 2);
  Result[0] := Byte(Data);
  Result[1] := Byte(Word(Data) shr 8);
end;

class function TByteUtil.GetBytes(Data: Integer): TBytes;
begin
  SetLength(Result, 4);
  Result[0] := Byte(Data and $FF);
  Result[1] := Byte((Data and $FF00) shr 8);
  Result[2] := Byte((Data and $FF0000) shr 16);
  Result[3] := Byte((Data and $FF000000) shr 24);
end;

class function TByteUtil.GetBytes(Data: Int64): TBytes;
begin
  SetLength(Result, 4);
  Result[0] := Byte(Data and $FF);
  Result[1] := Byte((Data shr 8) and $FF);
  Result[2] := Byte((Data shr 16) and $FF);
  Result[3] := Byte((Data shr 24) and $FF);
  Result[4] := Byte((Data shr 32) and $FF);
  Result[5] := Byte((Data shr 40) and $FF);
  Result[6] := Byte((Data shr 48) and $FF);
  Result[7] := Byte((Data shr 56) and $FF);
end;

class function TByteUtil.GetBytes(Data: Single): TBytes;
begin
  SetLength(Result, 4);
  Result[0] := Data.Bytes[0];
  Result[1] := Data.Bytes[1];
  Result[2] := Data.Bytes[2];
  Result[3] := Data.Bytes[3];
end;

class function TByteUtil.GetBytes(Data: Double): TBytes;
begin
  SetLength(Result, 4);
  Result[0] := Data.Bytes[0];
  Result[1] := Data.Bytes[1];
  Result[2] := Data.Bytes[2];
  Result[3] := Data.Bytes[3];
  Result[4] := Data.Bytes[4];
  Result[5] := Data.Bytes[5];
  Result[6] := Data.Bytes[6];
  Result[7] := Data.Bytes[7];
end;

class function TByteUtil.GetBytes(Data: string; Encoding: TEncoding): TBytes;
begin
  Result := Encoding.GetBytes(Data);
end;

class function TByteUtil.GetBytes(Data: string): TBytes;
begin
  Result := TEncoding.ANSI.GetBytes(Data);
end;

class function TByteUtil.GetBytes(DateTime: TDateTime; IsTime: boolean): TBytes;
begin
  if IsTime then
  begin
    Result := GetBytesFromTime(DateTime);
  end
  else
  begin
    Result := GetBytesFromDateTime(DateTime);
  end;
end;

class function TByteUtil.GetBytesFromDateTime(DateTime: TDateTime): TBytes;
var
  Year: SmallInt;
  Month: Byte;
  Day: Byte;
  Hour: Byte;
  Minute: Byte;
  Second: Byte;
  MicroSecond: Integer;
  Tmp: TBytes;
begin
  Year := TDateTimeUtil.GetYear(DateTime);
  Month := TDateTimeUtil.GetMonth(DateTime);
  Day := TDateTimeUtil.GetDay(DateTime);
  Hour := TDateTimeUtil.GetHour(DateTime);
  Minute := TDateTimeUtil.GetMinute(DateTime);
  Second := TDateTimeUtil.GetSecond(DateTime);
  MicroSecond := TDateTimeUtil.GetMicroSecond(DateTime);
  // Byte[] Bytes = null;
  // Byte[] Tmp = null;
  if (Year = 0) and (Month = 0) and (Day = 0) and (Hour = 0) and (Minute = 0)
    and (Second = 0) and (MicroSecond = 0) then
  begin
    SetLength(Result, 1);
    Result[0] := 0;
  end
  else if (Hour = 0) and (Minute = 0) and (Second = 0) and (MicroSecond = 0)
  then
  begin
    SetLength(Result, 1 + 4);
    Result[0] := 4;
    Tmp := GetBytes(Year);
    Result[1] := Tmp[0];
    Result[2] := Tmp[1];
    Result[3] := Month;
    Result[4] := Day;
  end
  else if MicroSecond = 0 then
  begin
    SetLength(Result, 1 + 7);
    Result[0] := 7;
    Tmp := GetBytes(Year);
    Result[1] := Tmp[0];
    Result[2] := Tmp[1];
    Result[3] := Month;
    Result[4] := Day;
    Result[5] := Hour;
    Result[6] := Minute;
    Result[7] := Second;
  end
  else
  begin
    SetLength(Result, 1 + 11);
    Result[0] := 11;
    Tmp := GetBytes(Year);
    Result[1] := Tmp[0];
    Result[2] := Tmp[1];
    Result[3] := Month;
    Result[4] := Day;
    Result[5] := Hour;
    Result[6] := Minute;
    Result[7] := Second;
    Tmp := GetBytes(MicroSecond);
    Result[8] := Tmp[0];
    Result[9] := Tmp[1];
    Result[10] := Tmp[2];
    Result[11] := Tmp[3];
  end;
end;

class function TByteUtil.GetBytesFromTime(Time: TTime): TBytes;
var
  Day: Integer;
  Hour: Byte;
  Minute: Byte;
  Second: Byte;
  MicroSecond: Integer;
  Tmp: TBytes;
begin
  Day := 0;
  Hour := TDateTimeUtil.GetHour(Time);
  Minute := TDateTimeUtil.GetMinute(Time);
  Second := TDateTimeUtil.GetSecond(Time);
  MicroSecond := TDateTimeUtil.GetMicroSecond(Time);
  if (Day = 0) and (Hour = 0) and (Minute = 0) and (Second = 0) and
    (MicroSecond = 0) then
  begin
    SetLength(Result, 1);
    Result[0] := 0;
  end
  else if MicroSecond = 0 then
  begin
    SetLength(Result, 1 + 8);
    Result[0] := 8;
    Result[1] := 0; // is_negative (1) -- (1 if minus, 0 for plus)
    Tmp := GetBytes(Day);
    Result[2] := Tmp[0];
    Result[3] := Tmp[1];
    Result[4] := Tmp[2];
    Result[5] := Tmp[3];
    Result[6] := Hour;
    Result[7] := Minute;
    Result[8] := Second;
  end
  else
  begin
    SetLength(Result, 1 + 12);
    Result[0] := 12;
    Result[1] := 0; // is_negative (1) -- (1 if minus, 0 for plus)
    Tmp := GetBytes(Day);
    Result[2] := Tmp[0];
    Result[3] := Tmp[1];
    Result[4] := Tmp[2];
    Result[5] := Tmp[3];
    Result[6] := Hour;
    Result[7] := Minute;
    Result[8] := Second;
    Tmp := GetBytes(MicroSecond);
    Result[9] := Tmp[0];
    Result[10] := Tmp[1];
    Result[11] := Tmp[2];
    Result[12] := Tmp[3];
  end;
end;

class function TByteUtil.GetChar(Bytes: TBytes): Char;
begin
  Result := Char(($FF and Bytes[0]) or ($FF00 and (Bytes[1] shl 8)));
end;

class function TByteUtil.GetDate(Bytes: TBytes): string;
begin
  Result := TEncoding.ANSI.GetString(Bytes);
end;

class function TByteUtil.GetDouble(Bytes: TBytes): Double;
begin
  Result := Double.Parse(TEncoding.ANSI.GetString(Bytes));
end;

class function TByteUtil.GetFloat(Bytes: TBytes): Single;
begin
  Result := Single.Parse(TEncoding.ANSI.GetString(Bytes));
end;

class function TByteUtil.GetInt(Bytes: TBytes): Integer;
begin
  Result := Integer.Parse(TEncoding.ANSI.GetString(Bytes));
end;

class function TByteUtil.GetLong(Bytes: TBytes): Int64;
begin
  Result := Int64.Parse(TEncoding.ANSI.GetString(Bytes));
end;

class function TByteUtil.GetShort(Bytes: TBytes): SmallInt;
begin
  Result := SmallInt.Parse(TEncoding.ANSI.GetString(Bytes));
end;

class function TByteUtil.GetString(Bytes: TBytes): string;
begin
  Result := TEncoding.UTF8.GetString(Bytes);
end;

class function TByteUtil.GetTime(Bytes: TBytes): string;
begin
  Result := TEncoding.ANSI.GetString(Bytes);
end;

class function TByteUtil.GetTimeStmap(Bytes: TBytes): string;
begin
  Result := TEncoding.ANSI.GetString(Bytes);
end;

class function TByteUtil.GetString(Bytes: TBytes; Encoding: TEncoding): string;
begin
  Result := Encoding.GetString(Bytes);
end;

{ TDateTimeUtil }

class function TDateTimeUtil.ParseDateTime(DateTimeStr: string): TDateTime;
begin
  Result := ParseDateTime(DateTimeStr, DEFAULT_DATETIME_PATTERN);
end;

class function TDateTimeUtil.DEFAULT_DATETIME_PATTERN: TFormatSettings;
begin
  Result := TFormatSettings.Create;
  Result.DateSeparator := '-';
  Result.TimeSeparator := ':';
  Result.LongDateFormat := 'yyyy-mm-dd';
  Result.LongTimeFormat := 'hh:nn:ss';
end;

class function TDateTimeUtil.DEFAULT_TIME_PATTERN: TFormatSettings;
begin
  Result := TFormatSettings.Create;
  Result.TimeSeparator := ':';
  Result.LongTimeFormat := 'hh:nn:ss';
end;

class function TDateTimeUtil.FULL_DATETIME_PATTERN: TFormatSettings;
begin
  Result := TFormatSettings.Create;
  Result.DateSeparator := '-';
  Result.TimeSeparator := ':';
  Result.LongDateFormat := 'yyyy-mm-dd';
  Result.LongTimeFormat := 'hh:nn:ss.zzz';
end;

class function TDateTimeUtil.FULL_TIME_PATTERN: TFormatSettings;
begin
  Result := TFormatSettings.Create;
  Result.TimeSeparator := ':';
  Result.LongTimeFormat := 'hh:nn:ss.zzz';
end;

class function TDateTimeUtil.GetDay(DateTime: TDateTime): Byte;
begin
  Result := DayOf(DateTime);
end;

class function TDateTimeUtil.GetHour(DateTime: TDateTime): Byte;
begin
  Result := HourOf(DateTime);
end;

class function TDateTimeUtil.GetMicroSecond(DateTime: TDateTime): Word;
begin
  Result := MilliSecondOf(DateTime) * 1000;
end;

class function TDateTimeUtil.GetMinute(DateTime: TDateTime): Byte;
begin
  Result := MinuteOf(DateTime);
end;

class function TDateTimeUtil.GetMonth(DateTime: TDateTime): Byte;
begin
  Result := MonthOf(DateTime);
end;

class function TDateTimeUtil.GetSecond(DateTime: TDateTime): Byte;
begin
  Result := SecondOf(DateTime);
end;

class function TDateTimeUtil.GetYear(DateTime: TDateTime): Word;
begin
  Result := YearOf(DateTime);
end;

class function TDateTimeUtil.ONLY_DATE_PATTERN: TFormatSettings;
begin
  Result := TFormatSettings.Create;
  Result.DateSeparator := '-';
end;

class function TDateTimeUtil.ParseDateTime(DateTimeStr: string;
  DatePattern: TFormatSettings): TDateTime;
begin
  Result := StrToDateTime(DateTimeStr, DatePattern);
end;

{ TTimeUtil }

class function TTimeUtil.CurrentTimeMillis: Int64;
begin
  Result := MilliSecondsBetween(Now, 0);
end;

class function TTimeUtil.CurrentTimeNanos: Int64;
begin
  Result := CurrentTimeMillis * 1000000;
end;

end.

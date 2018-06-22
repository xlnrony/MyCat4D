unit MyCat.BackEnd.Mysql;

interface

uses
  System.Classes, System.SysUtils, Data.FmtBcd;

type
  TMySQLMessage = record
  public const
    EMPTY_BYTES: TBytes = [];
    NULL_LENGTH: Int64 = -1;
  private
    FData: TBytes;
    FPosition: Integer;
  public
    constructor Create(Data: TBytes);
    function Length: Integer;
    property Position: Integer read FPosition write FPosition;
    function Bytes: TBytes;
    procedure Move(I: Integer);
    function HasRemaining: Boolean;
    function ReadByte(I: Integer): Byte; overload;
    function ReadByte: Byte; overload;
    function ReadUB2: Integer;
    function ReadUB3: Integer;
    function ReadUB4: Int64;
    function ReadInt: Integer;
    function ReadFloat: Single;
    function ReadLong: Int64;
    function ReadDouble: Double;
    function ReadLength: Int64;
    function ReadBytes: TBytes; overload;
    function ReadBytes(L: Integer): TBytes; overload;
    function ReadBytesWithNull: TBytes;
    function ReadBytesWithLength: TBytes;
    function ReadString: string; overload;
    function ReadString(Encoding: TEncoding): string; overload;
    function ReadStringWithNull: string; overload;
    function ReadStringWithNull(Encoding: TEncoding): string; overload;
    function ReadStringWithLength: string; overload;
    function ReadStringWithLength(Encoding: TEncoding): string; overload;
    function ReadTime: TTime;
    function ReadDateTime: TDateTime;
    function ReadBCD: TBcd;
  end;

  TStreamHelper = class helper for TStream
  public const
    EMPTY_BYTES: TBytes = [];
    NULL_LENGTH: Int64 = -1;
  public
    procedure WriteUB2(I: Integer);
    procedure WriteUB3(I: Integer);
    procedure WriteInt(I: Integer);
    procedure WriteFloat(F: Single);
    procedure WriteUB4(L: Integer);
    procedure WriteLong(L: Int64);
    procedure WriteDouble(D: Double);
    procedure WriteLength(L: Int64);
    procedure WriteWithNull(Src: TBytes);
    procedure WriteWithLength(Src: TBytes); overload;
    procedure WriteWithLength(Src: TBytes; NullValue: Byte); overload;
    class function GetLength(L: Int64): Integer; overload; static;
    class function GetLength(Src: TBytes): Integer; overload; static;
    function ReadByte: Byte;
    function ReadUB2: Integer;
    function ReadUB3: Integer;
    function ReadInt: Integer;
    function ReadFloat: Single;
    function ReadUB4: Int64;
    function ReadLong: Int64;
    function ReadDouble: Double;
    function ReadWithLength: TBytes;
    function ReadLength: Int64;
  end;

  // public static final void write(OutputStream out, byte b) throws IOException {
  // out.write(b & 0xff);
  // }
  //
  // public static final void writeUB2(OutputStream out, int i) throws IOException {
  // byte[] b = new byte[2];
  // b[0] = (byte) (i & 0xff);
  // b[1] = (byte) (i >>> 8);
  // out.write(b);
  // }
  //
  // public static final void writeUB3(OutputStream out, int i) throws IOException {
  // byte[] b = new byte[3];
  // b[0] = (byte) (i & 0xff);
  // b[1] = (byte) (i >>> 8);
  // b[2] = (byte) (i >>> 16);
  // out.write(b);
  // }
  //
  // public static final void writeInt(OutputStream out, int i) throws IOException {
  // byte[] b = new byte[4];
  // b[0] = (byte) (i & 0xff);
  // b[1] = (byte) (i >>> 8);
  // b[2] = (byte) (i >>> 16);
  // b[3] = (byte) (i >>> 24);
  // out.write(b);
  // }
  //
  // public static final void writeFloat(OutputStream out, float f) throws IOException {
  // writeInt(out, Float.floatToIntBits(f));
  // }
  //
  // public static final void writeUB4(OutputStream out, long l) throws IOException {
  // byte[] b = new byte[4];
  // b[0] = (byte) (l & 0xff);
  // b[1] = (byte) (l >>> 8);
  // b[2] = (byte) (l >>> 16);
  // b[3] = (byte) (l >>> 24);
  // out.write(b);
  // }
  //
  // public static final void writeLong(OutputStream out, long l) throws IOException {
  // byte[] b = new byte[8];
  // b[0] = (byte) (l & 0xff);
  // b[1] = (byte) (l >>> 8);
  // b[2] = (byte) (l >>> 16);
  // b[3] = (byte) (l >>> 24);
  // b[4] = (byte) (l >>> 32);
  // b[5] = (byte) (l >>> 40);
  // b[6] = (byte) (l >>> 48);
  // b[7] = (byte) (l >>> 56);
  // out.write(b);
  // }
  //
  // public static final void writeDouble(OutputStream out, double d) throws IOException {
  // writeLong(out, Double.doubleToLongBits(d));
  // }
  //
  //
  // public static final void writeLength(OutputStream out, long length) throws IOException {
  // if (length < 251) {
  // out.write((byte) length);
  // } else if (length < 0x10000L) {
  // out.write((byte) 252);
  // writeUB2(out, (int) length);
  // } else if (length < 0x1000000L) {
  // out.write((byte) 253);
  // writeUB3(out, (int) length);
  // } else {
  // out.write((byte) 254);
  // writeLong(out, length);
  // }
  // }
  //
  // public static final void writeWithNull(OutputStream out, byte[] src) throws IOException {
  // out.write(src);
  // out.write((byte) 0);
  // }
  //
  // public static final void writeWithLength(OutputStream out, byte[] src) throws IOException {
  // int length = src.length;
  // if (length < 251) {
  // out.write((byte) length);
  // } else if (length < 0x10000L) {
  // out.write((byte) 252);
  // writeUB2(out, length);
  // } else if (length < 0x1000000L) {
  // out.write((byte) 253);
  // writeUB3(out, length);
  // } else {
  // out.write((byte) 254);
  // writeLong(out, length);
  // }
  // out.write(src);
  // }
  //
  // }

implementation

uses
  System.DateUtils;

{ TStreamHelper }

class function TStreamHelper.GetLength(Src: TBytes): Integer;
var
  L: Integer;
begin
  L := Length(Src);
  if L < 251 then
  begin
    Exit(1 + L);
  end
  else if L < $10000 then
  begin
    Exit(3 + L);
  end
  else if L < $1000000 then
  begin
    Exit(4 + L);
  end
  else
  begin
    Exit(9 + L);
  end;
end;

function TStreamHelper.ReadByte: Byte;
begin
  ReadBufferData(Result);
end;

function TStreamHelper.ReadDouble: Double;
var
  B: TBytes;
begin
  ReadBuffer(B, 8);
  Result.Bytes[0] := B[0];
  Result.Bytes[1] := B[1];
  Result.Bytes[2] := B[2];
  Result.Bytes[3] := B[3];
  Result.Bytes[4] := B[4];
  Result.Bytes[5] := B[5];
  Result.Bytes[6] := B[6];
  Result.Bytes[7] := B[7];
end;

function TStreamHelper.ReadFloat: Single;
var
  B: TBytes;
begin
  ReadBuffer(B, 4);
  Result.Bytes[0] := B[0];
  Result.Bytes[1] := B[1];
  Result.Bytes[2] := B[2];
  Result.Bytes[3] := B[3];
end;

function TStreamHelper.ReadInt: Integer;
var
  B: TBytes;
begin
  ReadBuffer(B, 4);
  Result := B[0] and $FF;
  Result := Result or ((B[1] and $FF) shl 8);
  Result := Result or ((B[2] and $FF) shl 16);
  Result := Result or ((B[3] and $FF) shl 24);
end;

function TStreamHelper.ReadLength: Int64;
var
  L: Integer;
begin
  L := ReadByte;
  case L of
    251:
      begin
        Result := NULL_LENGTH;
      end;
    252:
      begin
        Result := ReadUB2;
      end;
    253:
      begin
        Result := ReadUB3;
      end;
    254:
      begin
        Result := ReadLong;
      end;
  else
    begin
      Result := L;
    end;
  end;
end;

function TStreamHelper.ReadLong: Int64;
var
  B: TBytes;
begin
  ReadBuffer(B, 8);
  Result := B[0] and $FF;
  Result := Result or (Int64(B[1]) shl 8);
  Result := Result or (Int64(B[2]) shl 16);
  Result := Result or (Int64(B[3]) shl 24);
  Result := Result or (Int64(B[4]) shl 32);
  Result := Result or (Int64(B[5]) shl 40);
  Result := Result or (Int64(B[6]) shl 48);
  Result := Result or (Int64(B[7]) shl 56);
end;

function TStreamHelper.ReadUB2: Integer;
var
  B: TBytes;
begin
  ReadBuffer(B, 2);
  Result := B[0] and $FF;
  Result := Result or ((B[1] and $FF) shl 8);
end;

function TStreamHelper.ReadUB3: Integer;
var
  B: TBytes;
begin
  ReadBuffer(B, 3);
  Result := B[0] and $FF;
  Result := Result or ((B[1] and $FF) shl 8);
  Result := Result or ((B[2] and $FF) shl 16);
end;

function TStreamHelper.ReadUB4: Int64;
var
  B: TBytes;
begin
  ReadBuffer(B, 4);
  Result := B[0] and $FF;
  Result := Result or ((B[1] and $FF) shl 8);
  Result := Result or ((B[2] and $FF) shl 16);
  Result := Result or ((B[3] and $FF) shl 24);
end;

function TStreamHelper.ReadWithLength: TBytes;
var
  L: Integer;
begin
  L := ReadLength;
  if L <= 0 then
  begin
    Exit(EMPTY_BYTES);
  end;
  SetLength(Result, L);
  ReadBuffer(Result, L);
end;

class function TStreamHelper.GetLength(L: Int64): Integer;
begin
  if L < 251 then
  begin
    Exit(1);
  end
  else if L < $10000 then
  begin
    Exit(3);
  end
  else if L < $1000000 then
  begin
    Exit(4);
  end
  else
  begin
    Exit(9);
  end;
end;

procedure TStreamHelper.WriteDouble(D: Double);
begin
  WriteData(D.Bytes[0]);
  WriteData(D.Bytes[1]);
  WriteData(D.Bytes[2]);
  WriteData(D.Bytes[3]);
  WriteData(D.Bytes[4]);
  WriteData(D.Bytes[5]);
  WriteData(D.Bytes[6]);
  WriteData(D.Bytes[7]);
end;

procedure TStreamHelper.WriteFloat(F: Single);
begin
  WriteData(F.Bytes[0]);
  WriteData(F.Bytes[1]);
  WriteData(F.Bytes[2]);
  WriteData(F.Bytes[3]);
end;

procedure TStreamHelper.WriteInt(I: Integer);
begin
  WriteData(Byte(I and $FF));
  WriteData(Byte(I shr 8));
  WriteData(Byte(I shr 16));
  WriteData(Byte(I shr 24));
end;

procedure TStreamHelper.WriteLength(L: Int64);
begin
  if L < 251 then
  begin
    WriteData(Byte(L));
  end
  else if L < $10000 then
  begin
    WriteData(Byte(252));
    WriteUB2(Integer(L));
  end
  else if L < $1000000 then
  begin
    WriteData(Byte(253));
    WriteUB3(Integer(L));
  end
  else
  begin
    WriteData(Byte(254));
    WriteLong(L);
  end;
end;

procedure TStreamHelper.WriteLong(L: Int64);
begin
  WriteData(Byte(L and $FF));
  WriteData(Byte(L shr 8));
  WriteData(Byte(L shr 16));
  WriteData(Byte(L shr 24));
  WriteData(Byte(L shr 32));
  WriteData(Byte(L shr 40));
  WriteData(Byte(L shr 48));
  WriteData(Byte(L shr 56));
end;

procedure TStreamHelper.WriteUB2(I: Integer);
begin
  WriteData(Byte(I and $FF));
  WriteData(Byte(I shr 8));
end;

procedure TStreamHelper.WriteUB3(I: Integer);
begin
  WriteData(Byte(I and $FF));
  WriteData(Byte(I shr 8));
  WriteData(Byte(I shr 16));
end;

procedure TStreamHelper.WriteUB4(L: Integer);
begin
  WriteData(Byte(L and $FF));
  WriteData(Byte(L shr 8));
  WriteData(Byte(L shr 16));
  WriteData(Byte(L shr 24));
end;

procedure TStreamHelper.WriteWithLength(Src: TBytes);
var
  L: Integer;
begin
  L := Length(Src);
  if L < 251 then
  begin
    WriteData(Byte(L));
  end
  else if L < $10000 then
  begin
    WriteData(Byte(252));
    WriteUB2(L);
  end
  else if L < $1000000 then
  begin
    WriteData(Byte(253));
    WriteUB3(L);
  end
  else
  begin
    WriteData(Byte(254));
    WriteLong(L);
  end;
  WriteData(Src, L);
end;

procedure TStreamHelper.WriteWithLength(Src: TBytes; NullValue: Byte);
begin
  if Src = nil then
  begin
    WriteData(NullValue);
  end
  else
  begin
    WriteWithLength(Src);
  end;
end;

procedure TStreamHelper.WriteWithNull(Src: TBytes);
begin
  WriteData(Src, Length(Src));
  WriteData(Byte(0));
end;

{ TMySQLMessage }

function TMySQLMessage.Bytes: TBytes;
begin
  Exit(FData);
end;

constructor TMySQLMessage.Create(Data: TBytes);
begin
  FData := Data;
  FPosition := 0;
end;

function TMySQLMessage.HasRemaining: Boolean;
begin
  Result := Length > FPosition;
end;

function TMySQLMessage.Length: Integer;
begin
  Result := System.Length(FData);
end;

procedure TMySQLMessage.Move(I: Integer);
begin
  Inc(FPosition, I);
end;

function TMySQLMessage.ReadByte: Byte;
begin
  Result := FData[FPosition];
  Inc(FPosition);
end;

function TMySQLMessage.ReadBCD: TBcd;
begin
  Result := StrToBcd(ReadStringWithLength);
end;

function TMySQLMessage.ReadBytes(L: Integer): TBytes;
begin
  if FPosition >= (Length - L) then
  begin
    Exit(EMPTY_BYTES);
  end;
  Result := Copy(FData, FPosition, L);
  Inc(FPosition, L);
end;

function TMySQLMessage.ReadBytesWithLength: TBytes;
var
  L: Integer;
begin
  L := Integer(ReadLength);
  if L = NULL_LENGTH then
  begin
    Exit(nil);
  end;
  if L <= 0 then
  begin
    Exit(EMPTY_BYTES);
  end;

  Result := Copy(FData, FPosition, L);
  Inc(FPosition, L);
end;

function TMySQLMessage.ReadBytesWithNull: TBytes;
var
  Offset: Integer;
  I: Integer;
begin
  if FPosition >= Length then
  begin
    Exit(EMPTY_BYTES);
  end;
  Offset := -1;
  for I := Position to Length - 1 do
  begin
    if FData[I] = 0 then
    begin
      Offset := I;
      break;
    end;
  end;
  case Offset of
    - 1:
      begin
        Result := Copy(FData, FPosition, Length - FPosition);
        FPosition := Length;
      end;
    0:
      begin
        Inc(FPosition);
        Exit(EMPTY_BYTES);
      end;
  else
    begin
      Result := Copy(FData, FPosition, Offset - FPosition);
      FPosition := Offset + 1;
    end;
  end;
end;

function TMySQLMessage.ReadBytes: TBytes;
begin
  if FPosition >= Length then
  begin
    Exit(EMPTY_BYTES);
  end;
  Result := Copy(FData, FPosition, Length - FPosition);
  FPosition := Length;
end;

function TMySQLMessage.ReadDateTime: TDateTime;
var
  L: Byte;
  Year: Integer;
  Month: Byte;
  Date: Byte;
  Hour: Integer;
  Minute: Integer;
  Second: Integer;
  Nanos: Int64;
begin
  L := ReadByte;
  Year := ReadUB2;
  Month := ReadByte - 1;
  Date := ReadByte;
  Hour := ReadByte;
  Minute := ReadByte;
  Second := ReadByte;
  if L = 11 then
  begin
    Nanos := ReadUB4;
    Result := EncodeDateTime(Year, Month, Date, Hour, Minute, Second,
      Nanos div 1000000);
  end
  else
  begin
    Result := EncodeDateTime(Year, Month, Date, Hour, Minute, Second, 0);
  end;
end;

function TMySQLMessage.ReadDouble: Double;
begin
  Result.Bytes[0] := FData[FPosition];
  Inc(FPosition);
  Result.Bytes[1] := FData[FPosition];
  Inc(FPosition);
  Result.Bytes[2] := FData[FPosition];
  Inc(FPosition);
  Result.Bytes[3] := FData[FPosition];
  Inc(FPosition);
  Result.Bytes[4] := FData[FPosition];
  Inc(FPosition);
  Result.Bytes[5] := FData[FPosition];
  Inc(FPosition);
  Result.Bytes[6] := FData[FPosition];
  Inc(FPosition);
  Result.Bytes[7] := FData[FPosition];
  Inc(FPosition);
end;

function TMySQLMessage.ReadFloat: Single;
begin
  Result.Bytes[0] := FData[FPosition];
  Inc(FPosition);
  Result.Bytes[1] := FData[FPosition];
  Inc(FPosition);
  Result.Bytes[2] := FData[FPosition];
  Inc(FPosition);
  Result.Bytes[3] := FData[FPosition];
  Inc(FPosition);
end;

function TMySQLMessage.ReadInt: Integer;
begin
  Result := FData[FPosition] and $FF;
  Inc(FPosition);
  Result := Result or ((FData[Position] and $FF) shl 8);
  Inc(FPosition);
  Result := Result or ((FData[Position] and $FF) shl 16);
  Inc(FPosition);
  Result := Result or ((FData[Position] and $FF) shl 24);
  Inc(FPosition);
end;

function TMySQLMessage.ReadLength: Int64;
var
  L: Integer;
begin
  L := FData[FPosition] and $FF;
  Inc(FPosition);
  case L of
    251:
      begin
        Result := NULL_LENGTH;
      end;
    252:
      begin
        Result := ReadUB2;
      end;
    253:
      begin
        Result := ReadUB3;
      end;
    254:
      begin
        Result := ReadLong;
      end;
  else
    begin
      Result := L;
    end;
  end;
end;

function TMySQLMessage.ReadLong: Int64;
begin
  Result := FData[FPosition] and $FF;
  Inc(FPosition);
  Result := Result or (Int64(FData[Position]) shl 8);
  Inc(FPosition);
  Result := Result or (Int64(FData[Position]) shl 16);
  Inc(FPosition);
  Result := Result or (Int64(FData[Position]) shl 24);
  Inc(FPosition);
  Result := Result or (Int64(FData[Position]) shl 32);
  Inc(FPosition);
  Result := Result or (Int64(FData[Position]) shl 40);
  Inc(FPosition);
  Result := Result or (Int64(FData[Position]) shl 48);
  Inc(FPosition);
  Result := Result or (Int64(FData[Position]) shl 56);
  Inc(FPosition);
end;

function TMySQLMessage.ReadString(Encoding: TEncoding): string;
begin
  if FPosition >= Length then
  begin
    Exit('');
  end;
  Result := Encoding.GetString(FData, FPosition, Length - FPosition);
  FPosition := Length;
end;

function TMySQLMessage.ReadStringWithLength: string;
var
  L: Integer;
begin
  L := Integer(ReadLength);
  if L <= 0 then
  begin
    Exit('');
  end;
  Result := TEncoding.ANSI.GetString(FData, FPosition, L);
  Inc(FPosition, L);
end;

function TMySQLMessage.ReadStringWithLength(Encoding: TEncoding): string;
var
  L: Integer;
begin
  L := Integer(ReadLength);
  if L <= 0 then
  begin
    Exit('');
  end;
  Result := Encoding.GetString(FData, FPosition, L);
  Inc(FPosition, L);
end;

function TMySQLMessage.ReadStringWithNull(Encoding: TEncoding): string;
var
  Offset: Integer;
  I: Integer;
begin
  if (FPosition >= Length) then
  begin
    Exit('');
  end;
  Offset := -1;
  for I := FPosition to Length - 1 do
  begin
    if FData[I] = 0 then
    begin
      Offset := I;
      break;
    end;
  end;
  if Offset = -1 then
  begin
    Result := Encoding.GetString(FData, FPosition, Length - FPosition);
    FPosition := Length;
  end
  else if Offset > Position then
  begin
    Result := Encoding.GetString(FData, FPosition, Offset - FPosition);
    FPosition := Offset + 1;
  end
  else
  begin
    Inc(FPosition);
    Exit('');
  end;
end;

function TMySQLMessage.ReadTime: TTime;
var
  Hour: Integer;
  Minute: Integer;
  Second: Integer;
begin
  Move(6);
  Hour := ReadByte;
  Minute := ReadByte;
  Second := ReadByte;

  Result := EncodeTime(Hour, Minute, Second, 0);
end;

function TMySQLMessage.ReadStringWithNull: string;
var
  Offset: Integer;
  I: Integer;
begin
  if (FPosition >= Length) then
  begin
    Exit('');
  end;
  Offset := -1;
  for I := FPosition to Length - 1 do
  begin
    if FData[I] = 0 then
    begin
      Offset := I;
      break;
    end;
  end;
  if Offset = -1 then
  begin
    Result := TEncoding.ANSI.GetString(FData, FPosition, Length - FPosition);
    FPosition := Length;
  end
  else if Offset > Position then
  begin
    Result := TEncoding.ANSI.GetString(FData, FPosition, Offset - FPosition);
    FPosition := Offset + 1;
  end
  else
  begin
    Inc(FPosition);
    Exit('');
  end;
end;

function TMySQLMessage.ReadString: string;
begin
  if FPosition >= Length then
  begin
    Exit('');
  end;
  Result := TEncoding.ANSI.GetString(FData, FPosition, Length - FPosition);
  FPosition := Length;
end;

function TMySQLMessage.ReadUB2: Integer;
begin
  Result := FData[FPosition] and $FF;
  Inc(FPosition);
  Result := Result or ((FData[Position] and $FF) shl 8);
  Inc(FPosition);
end;

function TMySQLMessage.ReadUB3: Integer;
begin
  Result := FData[FPosition] and $FF;
  Inc(FPosition);
  Result := Result or ((FData[Position] and $FF) shl 8);
  Inc(FPosition);
  Result := Result or ((FData[Position] and $FF) shl 16);
  Inc(FPosition);
end;

function TMySQLMessage.ReadUB4: Int64;
begin
  Result := FData[FPosition] and $FF;
  Inc(FPosition);
  Result := Result or ((FData[Position] and $FF) shl 8);
  Inc(FPosition);
  Result := Result or ((FData[Position] and $FF) shl 16);
  Inc(FPosition);
  Result := Result or ((FData[Position] and $FF) shl 24);
  Inc(FPosition);
end;

function TMySQLMessage.ReadByte(I: Integer): Byte;
begin
  Result := FData[I];
end;

end.

unit CloudAPI.GoogleAnalitics.Extensions;

interface

uses
  System.Classes,
  System.Types;

type
  {$SCOPEDENUMS ON}
  TgaTypeTreatment = (pageview, screenview, event, transaction, item, social,
    Exception, timing);

  TgaSessionControllerState = (Empty, Start, &End);
  {$SCOPEDENUMS OFF}

  TgaExtension = class(TPersistent)
  public
    procedure FillData(const HitType: string; ADataStorage: TStringList);
      virtual; abstract;
  end;


  /// <summary>
  /// ����� ����
  /// </summary>
  TgaGeneral = class(TgaExtension)
  private
    FVersion: string;
    FTrackingId: string;
    FDataSource: string;
    FAnonymizingIP: Boolean;
    FQueueTime: Integer;
    FCacheLock: string;
  public
    procedure FillData(const HitType: string; ADataStorage: TStringList); override;
  public
    constructor Create;
  published
    /// <summary>
    /// ������ ���������
    /// </summary>
    /// <remarks>
    /// �������� ������������ ��� ���� ����� ���������.
    /// ������ ���������. ������� �������� � 1.
    /// ��� ��������� ������ � ��� ������, ���� � �������� ����� ������� ��������� ��� �������� �������������.
    /// </remarks>
    property Version: string read FVersion;
    /// <summary>
    /// ������������� ������������/������������� ���-�������
    /// </summary>
    /// <remarks>
    /// �������� ������������ ��� ���� ����� ���������.
    /// ������������� ������������/������������� ���-������� � ������� <c>UA-XXXX-Y</c>. � ����
    /// ��������������� ����������� ��� ���������� ������.
    /// </remarks>
    property TrackingId: string read FTrackingId write FTrackingId;
    /// <summary>
    /// �������� ������
    /// </summary>
    /// <remarks>
    /// �������������� ����.
    /// ��������� �������� ������ ��� ���������.
    /// ��������� �� analytics.js ����� ����� �������� web, ��������� �� ��������� SDK � �������� app.
    /// </remarks>
    property DataSource: string read FDataSource write FDataSource;
    /// <summary>
    /// ������������ IP
    /// </summary>
    /// <remarks>
    /// �������������� ����.
    /// IP-����� ����������� (��� �������) ����������� � ��������� �����.
    /// </remarks>
    property AnonymizingIP: Boolean read FAnonymizingIP write FAnonymizingIP;
    /// <summary>
    /// ����� � �������
    /// </summary>
    /// <remarks>
    /// �������������� ����.
    /// ������������ ��� ����� ������-��������� (��������� ���������). �������� ������������ ����� ��������� ������ (� �������������) ����� ��������, ����� ��������� ���������, � ��� ���������. �������� ������ ���� ������ ��� ����� 0. ���� �������� ��������� ������ ����, ��������� ����� ���� �� ����������.
    /// </remarks>
    property QueueTime: Integer read FQueueTime write FQueueTime;
    /// <summary>
    /// ���������� ����
    /// </summary>
    /// <remarks>
    /// �������������� ����.
    /// ������������ ��� �������� �������� ��������� �������� � �������� GET, ����� �������� � ������-������� �� ���������� ���������. ���� �������� ������ ���� ���������, ��� ���, �� ������ �����, ��������� ��������� ��������� ���������� ����������� ��������� �������������� ��������� � HTTP-�������. ��� �������� �� �������� � ������. ��� �������� �� �������� � ������.
    /// </remarks>
    property CacheLock: string read FCacheLock write FCacheLock;
  end;
  /// <summary>
  /// ������������
  /// </summary>

  TgaUser = class(TgaExtension)
  private
    FClientID: string;
    FUserID: string;
  public
    procedure FillData(const HitType: string; ADataStorage: TStringList); override;
  published
    /// <summary>
    /// ������������� �������
    /// </summary>
    /// <remarks>
    /// ��� ���� ������ ���� ���������, ���� � ������� �� ������ User ID (uid). � ������� �������� ����� ���� ����������� ��������� ������������� ���������� ������������, ���������� ��� ��������. �� ������ ���� ������������� ������ ����������� � �������� ����� cookie, ������� ��������� ��� ����, � � ������ ��������� ���������� � ��������� ������� ������������ ��� ������� ���������� �������������� ����������. � ���� ���� ������ ���� ������ ������������� ���������� ������������� (������ 4), ��� ������� � ����� http://www.ietf.org/rfc/rfc4122.txt.
    /// </remarks>
    property ClientID: string read FClientID write FClientID;
    /// <summary>
    /// ������������� ������������
    /// </summary>
    /// <remarks>
    /// ��� ���� �����������, ���� � ������� �� ����� ������������� �������. User ID � ��������� �������������, ������������� ������������ ���������� ����� ��� ������������� ���������� ������������. �� ������ ���� ���������, �. �. �� ��������� � ������ �����������, � ��� �������� �� ������ ����������� � ������� ������ cookie ��� �����-���� ������ ������� �������� ������ � Google Analytics.
    /// </remarks>
    property UserID: string read FUserID write FUserID;
  end;

  /// <summary>
  /// �����
  /// </summary>
  TgaSession = class(TgaExtension)
  private
    FSessionController: TgaSessionControllerState;
    FUserAgent: string;
    FIpOverride: string;
    FGeoID: string;
  protected
    procedure FillData(const HitType: string; ADataStorage: TStringList); override;
  published
    /// <summary>
    /// ���������� �������
    /// </summary>
    /// <remarks>
    /// ������������ ��� �������� �� ������������������ ������. ��� �������� start � ����� ��������� ���������� ����� �����, � ��� �������� end �� ���� ��������� ������������� ������� �����. ��� ��������� �������� ������������.
    /// </remarks>
    property SessionController: TgaSessionControllerState read
      FSessionController write FSessionController;
    /// <summary>
    /// ��������������� IP
    /// </summary>
    /// <remarks>
    /// �������������� ����.
    /// IP-����� ������������. ���� IP-����� ������ ���� ��������������, � ������� IPv4 ��� IPv6. IP ������������� ������ ���������������.
    /// </remarks>
    property IpOverride: string read FIpOverride write FIpOverride;
    /// <summary>
    /// ��������������� ������ ������������
    /// </summary>
    /// <remarks>
    /// �������������� ����.
    /// ����� ������������ ��������. �������� ��������, ��� Google ������������� ����������, ����������� ���������������� �������������� ������� ������������. ������������� ������������ ������ ��������� � ����� �������� � �������.
    /// </remarks>
    property UserAgent: string read FUserAgent write FUserAgent;
    /// <summary>
    /// ��������������� ���������
    /// </summary>
    /// <remarks>
    /// �������������� ����.
    /// �������������� �������������� ������������. ������������� �������������� ������ ������������ ����� ������������� ��� ������ ��� ������������� �������� ��� ������ ��� ������� (��. http://developers.google.com/analytics/devguides/collection/protocol/v1/geoid). ���� �������� �������������� ��� ��������, ������������ �� IP-������, � ��� ����� �������� ��������������� IP. ��� �������� ���� �������������� ��������� ����� ����� �������� (not set).
    /// </remarks>
    property GeoID: string read FGeoID write FGeoID;
  end;
  /// <summary>
  /// ��������� �������
  /// </summary>

  TgaTrafficSources = class(TgaExtension)
  private
    FDocumentReferrer: string;
    FCampaignName: string;
    FCampaignSource: string;
    FCampaignMedium: string;
    FCampaignKeyword: string;
    FCampaignContent: string;
    FCampaignID: string;
    FGoogleAdWordsID: string;
    FGoogleDisplayAdsID: string;
  public
    procedure FillData(const HitType: string; ADataStorage: TStringList); override;
  published
    /// <summary>
    ///  URL �������� � ���������
    /// </summary>
    /// <remarks>
    ///  �������������� ����.
    ///  ����������, � ������ URL �������� ������ �� ����. ��� �������� ������������ ��� ����������� ��������� �������. ������ �������� � URL.
    /// </remarks>
    property DocumentReferrer: string read FDocumentReferrer write FDocumentReferrer;
    /// <summary>
    ///  �������� ��������
    /// </summary>
    /// <remarks>
    ///  �������������� ����.
    ///  ��������� �������� ��������.
    /// </remarks>
    property CampaignName: string read FCampaignName write FCampaignName;
    /// <summary>
    ///  �������� ��������
    /// </summary>
    /// <remarks>
    ///  �������������� ����.
    ///  ��������� �������� ��������.
    /// </remarks>
    property CampaignSource: string read FCampaignSource write FCampaignSource;
    /// <summary>
    ///  ����� ��������
    /// </summary>
    /// <remarks>
    ///  �������������� ����.
    ///  ��������� ����� ��������.
    /// </remarks>
    property CampaignMedium: string read FCampaignMedium write FCampaignMedium;
    /// <summary>
    ///  �������� ����� ��������
    /// </summary>
    /// <remarks>
    ///  �������������� ����.
    ///  ���������� �������� ����� ��������.
    /// </remarks>
    property CampaignKeyword: string read FCampaignKeyword write FCampaignKeyword;
    /// <summary>
    ///  ���������� ��������
    /// </summary>
    /// <remarks>
    ///  �������������� ����.
    ///  ���������� ���������� ��������.
    /// </remarks>
    property CampaignContent: string read FCampaignContent write FCampaignContent;
    /// <summary>
    ///  ������������� ��������
    /// </summary>
    /// <remarks>
    ///  �������������� ����.
    ///  ���������� ������������� ��������.
    /// </remarks>
    property CampaignID: string read FCampaignID write FCampaignID;
    /// <summary>
    ///  ������������� Google �������
    /// </summary>
    /// <remarks>
    ///  �������������� ����.
    ///  ���������� ������������� Google �������.
    /// </remarks>
    property GoogleAdWordsID: string read FGoogleAdWordsID write FGoogleAdWordsID;
    /// <summary>
    ///  ������������� �������� ���������� Google
    /// </summary>
    /// <remarks>
    ///  �������������� ����.
    ///  ��������� ������������� �������� ���������� Google.
    /// </remarks>
    property GoogleDisplayAdsID: string read FGoogleDisplayAdsID write
      FGoogleDisplayAdsID;
  end;

  /// <summary>
  ///   ���������� � �������
  /// </summary>
  TgaSystem = class(TgaExtension)
  private
    FScreenResolution: TSizeF;
    FViewportSize: TSizeF;
    FDocumentEncoding: string;
    FScreenColors: string;
    FUserLanguage: string;
    FJavaEnabled: Boolean;
    FFlashVersion: string;
  protected
    procedure FillData(const HitType: string; ADataStorage: TStringList); override;
  published
    /// <summary>
    ///  ���������� ������
    /// </summary>
    /// <remarks>
    ///  �������������� ����.
    ///  ��������� ���������� ������.
    /// </remarks>
    property ScreenResolution: TSizeF read FScreenResolution write FScreenResolution;
    /// <summary>
    ///  ���� ���������
    /// </summary>
    /// <remarks>
    ///  �������������� ����.
    ///  ���������� ������ ������� ������� ��������/����������.
    /// </remarks>
    property ViewportSize: TSizeF read FViewportSize write FViewportSize;
    /// <summary>
    ///  ����������� ���������
    /// </summary>
    /// <remarks>
    ///  �������������� ����.
    ///  ���������� ����� �������� ��� ����������� ��������/���������.
    /// </remarks>
    property DocumentEncoding: string read FDocumentEncoding write FDocumentEncoding;
    /// <summary>
    ///  ����� ������
    /// </summary>
    /// <remarks>
    ///  �������������� ����.
    ///  ���������� ������� ������ ������.
    /// </remarks>
    property ScreenColors: string read FScreenColors write FScreenColors;
    /// <summary>
    ///  ���� ������������
    /// </summary>
    /// <remarks>
    ///  �������������� ����.
    ///  ���������� ���� ������������.
    /// </remarks>
    property UserLanguage: string read FUserLanguage write FUserLanguage;
    /// <summary>
    ///   ��������� Java ��������
    /// </summary>
    /// <remarks>
    ///  �������������� ����.
    ///  ���������, �������� �� ��������� Java.
    /// </remarks>
    property JavaEnabled: Boolean read FJavaEnabled write FJavaEnabled;
    /// <summary>
    ///   ������ Flash
    /// </summary>
    /// <remarks>
    ///  �������������� ����.
    ///  ��������� ������ Flash.
    /// </remarks>
    property FlashVersion: string read FFlashVersion write FFlashVersion;
  end;


  /// <summary>
  ///   ���������
  /// </summary>
  TgaHit = class(TgaExtension)
  private
    FHitType: TgaTypeTreatment;
    FNonInteractionHit: Boolean;
  protected
    procedure FillData(const HitType: string; ADataStorage: TStringList); override;
  public
    constructor Create;
  published
    /// <summary>
    ///   ��� ���������
    /// </summary>
    /// <remarks>
    ///   �������� ������������ ��� ���� ����� ���������.
    ///  ��� ���������. ��������� ��������: pageview, screenview, event, transaction, item, social, exception, timing.
    /// </remarks>
    property HitType: TgaTypeTreatment read FHitType write FHitType;
    /// <summary>
    ///   ��������� �������
    /// </summary>
    /// <remarks>
    ///   �������������� ����.
    ///   ��������� �� ��, ��� ��������� �� ������ ��������� ���������������.
    /// </remarks>
    property NonInteractionHit: Boolean read FNonInteractionHit write
      FNonInteractionHit default False;
  end;


  /// <summary>
  ///  ���������� � ����������
  /// </summary>
  TgaContentInformation = class(TgaExtension)
  private
    FDocumentPath: string;
    FDocumentLocationURL: string;
    FDocumentHostName: string;
    FDocumentTitle: string;
    FScreenName: string;
    FContentGroup: string;
    FLinkID: string;
  protected
    procedure FillData(const HitType: string; ADataStorage: TStringList); override;
  published
    /// <summary>
    ///   URL �������������� ���������
    /// </summary>
    /// <remarks>
    ///   �������������� ����.
    ///  ���� �������� ��������� �������� ������ URL (���� � ���������) ��������, �� ������� �������� �������. �������������� ��� ����� � ����+������ ����� � ������� ���������� dh � dp ��������������. ������� JavaScript ���������� URL, ��������� ���������� ���������� �������� document.location.origin, document.location.pathname � document.location.search. ���� � URL ���� �����-���� ������ ����������, ������� ��������, ����������� ��� ��������������, �� ����� �������. ��� ��������� ���� pageview ���������� ��������� ���� �������� dl, ���� ��������� dh � dp ������������.
    /// </remarks>
    property DocumentLocationURL: string read FDocumentLocationURL write
      FDocumentLocationURL;
    /// <summary>
    ///  ��� ����� ���������
    /// </summary>
    /// <remarks>
    ///  �������������� ����.
    ///  ��������� ��� �����, ��� �������� �������.
    /// </remarks>
    property DocumentHostName: string read FDocumentHostName write FDocumentHostName;
    /// <summary>
    ///   ���� � ���������
    /// </summary>
    /// <remarks>
    ///    �������������� ����.
    ///  ����� URL ��������, ������������ ����. ���� ������ ���������� � ������� ����� ����� (/). ��� ��������� ���� pageview ���������� ������� ���� �������� dl, ���� ������������ ��������� dh � dp.
    /// </remarks>
    property DocumentPath: string read FDocumentPath write FDocumentPath;
    /// <summary>
    ///  ��������� ���������
    /// </summary>
    /// <remarks>
    ///  �������������� ����.
    ///  ��������� ��������/���������.
    /// </remarks>
    property DocumentTitle: string read FDocumentTitle write FDocumentTitle;
    /// <summary>
    ///   �������� ������
    /// </summary>
    /// <remarks>
    ///    ����������� ��� ��������� ���� screenview (�������� ������).
    ///  ��� �������������� �������� ��� ���-�������� � ������������ � ��� ��������� ��������. �� ������������ � �������� �������� ������ ��� ��������� ���� screenview (�������� ������). ��� ���-�������� �� ��������� ������������ ���������� URL �������� (�������� dl "��� ����" ���� ���������� ���������� dh � dp).
    /// </remarks>
    property ScreenName: string read FScreenName write FScreenName;
    /// <summary>
    ///   ������ �������� (�� �������������� �� ������ ������)
    /// </summary>
    /// <remarks>
    ///   �������������� ����.
    ///   � ��� ����� ���� �� ���� ����� ��������, ������ �� ������� ������������� ����� �� 1 �� 5. ������ �� ��� � ���� ������� ����� �������� �� 100 ����� ��������. ��������� ��������� "������ ��������" ������ ���� �����, ������������ ��������� �������� � ������������� ���������. ��� ���� � �������� ����������� ������������ ����� ����� "/". ���� ����� ����� ���������� � ������ ��� ����� ������, ��� ����� �������. ���� ���� ���� ������ ��������� ��� ������, �� ��� ������� ���������. ��������, ������ "/a//b/" ������������� � "a/b".
    /// </remarks>
    property ContentGroup: string read FContentGroup write FContentGroup;
    /// <summary>
    ///   ������������� ������
    /// </summary>
    /// <remarks>
    ///   �������������� ����.
    ///  ������������� �������� DOM, �� ������� ����� ������������. ��� �������� ������������ ��� ���������� ������ �� ���� URL � ������� "���������� ��������" � �������, ����� ��� ������� �������� ���������� ��������� ������.
    /// </remarks>
    property LinkID: string read FLinkID write FLinkID;
  end;

 /// <summary>
 ///   ������������ ����������
 /// </summary>
  TgaAppTracking = class(TgaExtension)
  private
    FApplicationName: string;
    FApplicationID: string;
    FApplicationVersion: string;
    FApplicationInstallerID: string;
  protected
    procedure FillData(const HitType: string; ADataStorage: TStringList); override;
  published
    /// <summary>
    ///  �������� ����������
    /// </summary>
    /// <remarks>
    ///  �������������� ����.
    ///  ��������� �������� ����������. ��� ���� �������� ������������ ��� ���������, � ������� ���������� ������, ��������� � ����������� (��������, ������ ����������, ��� ������������� ��� ������������� �����������). ��� ���-�������� �������������.
    /// </remarks>
    property ApplicationName: string read FApplicationName write FApplicationName;
    /// <summary>
    ///   ������������� ����������
    /// </summary>
    /// <remarks>
    ///  �������������� ����.
    ///  ������������� ����������.
    /// </remarks>
    property ApplicationID: string read FApplicationID write FApplicationID;
    /// <summary>
    ///  ������ ����������
    /// </summary>
    /// <remarks>
    ///  �������������� ����.
    ///  ��������� ������ ����������.
    /// </remarks>
    property ApplicationVersion: string read FApplicationVersion write
      FApplicationVersion;
    /// <summary>
    ///  ������������� ����������� ����������
    /// </summary>
    /// <remarks>
    ///  �������������� ����.
    ///  ������������� ����������� ����������.
    /// </remarks>
    property ApplicationInstallerID: string read FApplicationInstallerID write
      FApplicationInstallerID;
  end;

  TgaException = class(TgaExtension)
  private
    FText: string;
    FIsFatal: Boolean;
  protected
    procedure FillData(const HitType: string; ADataStorage: TStringList); override;
  published
    /// <summary>
    ///
    /// </summary>
    /// <remarks>
    ///
    /// </remarks>
    property Text: string read FText write FText;
    /// <summary>
    ///
    /// </summary>
    /// <remarks>
    ///
    /// </remarks>
    property IsFatal: Boolean read FIsFatal write FIsFatal;
  end;

implementation

uses
  System.SysUtils;

type
  TgaTypeTreatmentHelper = record helper for TgaTypeTreatment
    function ToString: string;
  end;

  TSizeFHelper = record helper for TSizeF
    function ToString: string;
  end;

  TgaSessionControllerStateHelper = record helper for TgaSessionControllerState
    function ToString: string;
  end;

{ TggTypeTreatmentHelper }

function TgaTypeTreatmentHelper.ToString: string;
begin
  case Self of
    TgaTypeTreatment.pageview:
      Result := 'pageview';
    TgaTypeTreatment.screenview:
      Result := 'screenview';
    TgaTypeTreatment.event:
      Result := 'event';
    TgaTypeTreatment.transaction:
      Result := 'transaction';
    TgaTypeTreatment.item:
      Result := 'item';
    TgaTypeTreatment.social:
      Result := 'social';
    TgaTypeTreatment.Exception:
      Result := 'exception';
    TgaTypeTreatment.timing:
      Result := 'timing';
  end;
end;

{ TSizeHelper }

function TSizeFHelper.ToString: string;
begin
  Result := Height.ToString + 'x' + Width.ToString;
end;
{ TgaUser }

procedure TgaUser.FillData(const HitType: string; ADataStorage: TStringList);
begin
  if (ClientID.IsEmpty) and UserID.IsEmpty then
    raise EArgumentException.Create('A value is required for parameter ClientID or UserID');
  if not ClientID.IsEmpty then
    ADataStorage.AddPair('cid', ClientID);
  if not UserID.IsEmpty then
    ADataStorage.AddPair('uid', UserID);
end;

{ TgaSystem }

procedure TgaSystem.FillData(const HitType: string; ADataStorage: TStringList);
begin
  if not ScreenResolution.IsZero then
    ADataStorage.AddPair('sr', ScreenResolution.ToString);
  if not ViewportSize.IsZero then
    ADataStorage.AddPair('vp', ViewportSize.ToString);
  if not DocumentEncoding.IsEmpty then
    ADataStorage.AddPair('de', DocumentEncoding);
  if not ScreenColors.IsEmpty then
    ADataStorage.AddPair('sd', ScreenColors);
  if not UserLanguage.IsEmpty then
    ADataStorage.AddPair('ul', UserLanguage);
  ADataStorage.AddPair('je', JavaEnabled.ToString);
  if not FlashVersion.IsEmpty then
    ADataStorage.AddPair('fl', FlashVersion);
end;

{ TgaBase }

constructor TgaGeneral.Create;
begin
  inherited;
  FVersion := '1';
  FAnonymizingIP := False;
end;

procedure TgaGeneral.FillData(const HitType: string; ADataStorage: TStringList);
begin
  if not Version.IsEmpty then
    ADataStorage.AddPair('v', Version);
  if not TrackingId.IsEmpty then
    ADataStorage.AddPair('tid', TrackingId);
  if AnonymizingIP then
    ADataStorage.AddPair('aip', '1');
  if not DataSource.IsEmpty then
    ADataStorage.AddPair('ds', DataSource);
  if QueueTime > 0 then
    ADataStorage.AddPair('qt', QueueTime.ToString);
  if not CacheLock.IsEmpty then
    ADataStorage.AddPair('z', CacheLock);
end;

{ TgaSessionController }

procedure TgaSession.FillData(const HitType: string; ADataStorage: TStringList);
begin
  if not UserAgent.IsEmpty then
    ADataStorage.AddPair('ua', UserAgent);
  if not IpOverride.IsEmpty then
    ADataStorage.AddPair('uip', IpOverride);
  if SessionController <> TgaSessionControllerState.Empty then
    ADataStorage.AddPair('sc', SessionController.ToString);
  if not GeoID.IsEmpty then
    ADataStorage.AddPair('geoid', GeoID);
end;

{ TgaTgaSessionControllerStateHelper }

function TgaSessionControllerStateHelper.ToString: string;
begin
  case Self of
    TgaSessionControllerState.Empty:
      Result := '';
    TgaSessionControllerState.Start:
      Result := 'start';
    TgaSessionControllerState.&End:
      Result := 'end';
  end;
end;

{ TgaContentInformation }

procedure TgaContentInformation.FillData(const HitType: string; ADataStorage:
  TStringList);
begin
  if not DocumentLocationURL.IsEmpty then
    ADataStorage.AddPair('dl', DocumentLocationURL);
  if not DocumentHostName.IsEmpty then
    ADataStorage.AddPair('dh', DocumentHostName);
  if not DocumentPath.IsEmpty then
    ADataStorage.AddPair('dp', DocumentPath);
  if not DocumentTitle.IsEmpty then
    ADataStorage.AddPair('dt', DocumentTitle);
  if not ScreenName.IsEmpty then
    ADataStorage.AddPair('cd', ScreenName);
// if not ContentGroup.IsEmpty then
 //   ADataStorage.AddPair('cd', ContentGroup);
  if not LinkID.IsEmpty then
    ADataStorage.AddPair('linkid', LinkID);
end;

{ TgaException }

procedure TgaException.FillData(const HitType: string; ADataStorage: TStringList);
begin
  if (not Text.IsEmpty) and (HitType = 'exception') then
    ADataStorage.AddPair('exd', Text).AddPair('exf', IsFatal.ToInteger.ToString);
end;

{ TgaTrafficSources }

procedure TgaTrafficSources.FillData(const HitType: string; ADataStorage: TStringList);
begin
  if not DocumentReferrer.IsEmpty then
    ADataStorage.AddPair('dr', DocumentReferrer);
  if not CampaignName.IsEmpty then
    ADataStorage.AddPair('cn', CampaignName);
  if not CampaignSource.IsEmpty then
    ADataStorage.AddPair('cs', CampaignSource);
  if not CampaignMedium.IsEmpty then
    ADataStorage.AddPair('cm', CampaignMedium);
  if not CampaignKeyword.IsEmpty then
    ADataStorage.AddPair('ck', CampaignKeyword);
  if not CampaignContent.IsEmpty then
    ADataStorage.AddPair('cc', CampaignContent);
  if not CampaignID.IsEmpty then
    ADataStorage.AddPair('ci', CampaignID);
  if not GoogleAdWordsID.IsEmpty then
    ADataStorage.AddPair('gclid', GoogleAdWordsID);
  if not GoogleDisplayAdsID.IsEmpty then
    ADataStorage.AddPair('dclid', GoogleDisplayAdsID);
end;

{ TgaHit }

constructor TgaHit.Create;
begin
  FNonInteractionHit := False;
end;

procedure TgaHit.FillData(const HitType: string; ADataStorage: TStringList);
begin
  ADataStorage.AddPair('t', Self.HitType.ToString);
  if NonInteractionHit then
    ADataStorage.AddPair('ni', '1');
end;

{ TgaAppTracking }

procedure TgaAppTracking.FillData(const HitType: string; ADataStorage: TStringList);
begin
  if not ApplicationName.IsEmpty then
    ADataStorage.AddPair('an', ApplicationName);
  if not ApplicationID.IsEmpty then
    ADataStorage.AddPair('aid', ApplicationID);
  if not ApplicationVersion.IsEmpty then
    ADataStorage.AddPair('av', ApplicationVersion);
  if not ApplicationInstallerID.IsEmpty then
    ADataStorage.AddPair('aiid', ApplicationInstallerID);
end;

end.


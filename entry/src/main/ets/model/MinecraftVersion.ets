export interface MinecraftVersion {
  arguments: Arguments;
  assetIndex: AssetIndex;
  assets: string;
  complianceLevel: number;
  downloads: Downloads;
  id: string;
  jar: string;
  javaVersion: JavaVersion;
  libraries: Library[];
  logging: Logging;
  mainClass: string;
  minimumLauncherVersion: number;
  patches?: Patch[];
  releaseTime: string;
  root?: boolean;
  time: string;
  type: string;
}


type ArgumentItem = string | ArgumentRule;

export interface Arguments {
  game: ArgumentItem[];
  jvm: ArgumentItem[];
}
export interface ArgumentRule {
  rules: CompatibilityRule[];
  value: string | string[];
}
export interface OSRestriction{
  name?: string;
  version?: string;
  arch?: string;
}
export interface CompatibilityRule {
  action: 'allow' | 'disallow';
  os?: OSRestriction;
  features?: Record<string, boolean>;
}
export interface AssetIndex {
  totalSize: number;
  id: string;
  sha1: string;
  size: number;
  url: string;
}
export interface Downloads {
  server_mappings?: DownloadInfo;
  client_mappings?: DownloadInfo;
  client: DownloadInfo;
  server: DownloadInfo;
}
export interface DownloadInfo {
  sha1: string;
  size: number;
  url: string;
}
export interface JavaVersion {
  component: string;
  majorVersion: number;
}
export interface Library {
  name: string;
  downloads: LibraryDownloads;
  rules?: CompatibilityRule[];
  natives?: Record<string, string>;
  extract?: ExtractRule;
}
export interface LibraryDownloads {
  artifact?: Artifact;
  classifiers?: Record<string, Artifact>;
}
export interface Artifact {
  path: string;
  sha1: string;
  size: number;
  url: string;
}
export interface ExtractRule {
  exclude: string[];
}
export interface Logging {
  client: LoggingClient;
}
export interface LoggingClient {
  argument: string;
  file: LoggingFile;
  type: string;
}
export interface LoggingFile {
  id: string;
  sha1: string;
  size: number;
  url: string;
}
export interface Patch extends Omit<MinecraftVersion, 'patches' | 'root'> {
  priority: number;
  version: string;
}
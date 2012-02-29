package parts;

import world.Actor;

interface Part {
	public var actor:Actor;

	public function getKind():Kind;
}
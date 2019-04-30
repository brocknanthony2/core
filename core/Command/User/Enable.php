<?php
/**
 * @author Thomas Müller <thomas.mueller@tmit.eu>
 *
 * @copyright Copyright (c) 2018, ownCloud GmbH
 * @license AGPL-3.0
 *
 * This code is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License, version 3,
 * as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License, version 3,
 * along with this program.  If not, see <http://www.gnu.org/licenses/>
 *
 */

namespace OC\Core\Command\User;

use OC\User\SyncService;
use OCP\IUserManager;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Input\InputArgument;

class Enable extends Command {
	/** @var IUserManager */
	protected $userManager;
	/** @var SyncService */
	protected $syncService;

	/**
	 * @param IUserManager $userManager
	 */
	public function __construct(IUserManager $userManager, SyncService $syncService) {
		$this->userManager = $userManager;
		$this->syncService = $syncService;
		parent::__construct();
	}

	protected function configure() {
		$this
			->setName('user:enable')
			->setDescription('Enables the specified user.')
			->addArgument(
				'uid',
				InputArgument::REQUIRED,
				'The username.'
			);
	}

	protected function execute(InputInterface $input, OutputInterface $output) {
		$uid = $input->getArgument('uid');
		$user = $this->userManager->get($uid);
		if ($user === null) {
			$output->writeln('<error>User does not exist</error>');
			return;
		}

		if ($user->isEnabled() || !$this->syncService->userWillBeDisabled($uid)) {
			// keep the same old behaviour if the user is already enabled
			$user->setEnabled(true);
			$output->writeln('<info>The specified user is enabled</info>');
		} else {
			$output->writeln('<error>The user cannot be enabled due to user limits. Disable some users first</error>');
		}
	}
}
